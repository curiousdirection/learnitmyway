---
title: "What I learned building a URL shortener for real"
type: post
date: 2026-11-23T12:57:08+01:00
excerpt: In this article, I turn the classic URL shortener system design question into a real implementation and share the decisions that shaped it.
url: url-shortener
canonical: true
shareImage: /img/url-shortener/architecture.png
twitterLink:
extraContent:
---

I have been brushing up on my system design skills and I thought to myself "what if I just build a URL shortener myself?". So I did and the result is [on GitHub](https://github.com/curiousdirection/url-shortener)! I translated the classic interview-style system design question from something abstract into something concrete. With a coding agent this was feasible in a short amount of time.

<!--more-->
<!-- og:description -->

## Functional Requirements

![The web page, with a link to this article shortened to a 7-character code](/img/url-shortener/ui.png)

- A user can enter a URL into a form and they are given a short URL in return
- When a user accesses a short URL they are redirected to the original URL (e.g. your-domain.com/abcd123 -> www.example.com/a/long/path)

## Assumptions

- Short codes can be guessable
- 1 billion stored URLs
- 100 million daily active users
- 1 billion redirects per day (~12k requests per second) with spikes up to 100x when a link goes viral (~1.2 million requests per second)

## High level design

![Architecture: the client calls CloudFront, which serves the web page from S3 and calls the Lambda function, which reads and writes the urls table in DynamoDB](/img/url-shortener/architecture.svg)

### Creating a URL

1. When a user enters a URL an HTTP POST request is sent to /api/urls, which is served by a Lambda function
2. The function creates a random base62 (a-z, A-Z, 0-9) 7-character code (~3.5 trillion possible combinations) and stores it in DynamoDB
3. The write only succeeds if the code is free (`attribute_not_exists(code)`). If the code already exists a new one is generated instead
4. After the code is created the Lambda function returns it in the response with a 201 Created status code

### Hitting a short URL

1. When a user fetches a short URL (e.g. your-domain.com/abcd123) an HTTP GET request is sent to /:code, which goes to the CloudFront CDN first
2. If the CDN has the redirect cached it responds straight away, without reaching the Lambda function
3. Otherwise the CDN calls the Lambda function, which fetches the short code from DynamoDB and returns a 302 Found status code with the URL to redirect to
4. If the code is not found (DynamoDB defaults to being eventually consistent) a consistent read is made, so a link created a moment ago doesn't return a 404
5. The CDN caches the redirect for one year, but browsers don't cache it at all

Why a 302 and not a 301? A 301 is permanent, so browsers can keep it indefinitely and you can't easily take the link back. With a 302 that only the CDN caches, taking down a link is just a cache invalidation.

## Interesting decisions

If you look at the [repo's decision records](https://github.com/curiousdirection/url-shortener/tree/main/docs/decisions) you will see how I arrived at the final design. I've listed the more interesting ones below. For each one I've linked the decision record if you are interested in more detail, which justifies each decision including consequences, alternatives and when to revisit.

### Replacing Redis with a Postgres sequence

The original design had a counter, which was used to generate the short code. The idea was that you increment the counter every time a URL is created. For the counter Redis was chosen. One of the first decisions I made was to replace Redis with a simple Postgres sequence. It was simpler to manage and reduced the points of failure. Although I hadn't fully thought through recovery at this point, having two separate DBs that can go out of sync would have been a challenge to solve.

[Decision record](https://github.com/curiousdirection/url-shortener/blob/main/docs/decisions/0005-postgres-sequence-for-short-codes.md)

### Replacing EC2 with ECS Express Mode

The original design was deployed with a Network Load Balancer and EC2 with auto scaling. This could have likely been a viable end solution, and it would probably be the cheapest at full scale, but it was a lot of infrastructure to manage so I switched to ECS Express Mode instead.

[Decision record](https://github.com/curiousdirection/url-shortener/blob/main/docs/decisions/0002-deploy-with-ecs-express-mode.md)

### Replacing ECS Express Mode and RDS with Lambda and DynamoDB

By this point I was planning to use a CDN to cache URLs. What I hadn't realised was that using a CDN to cache URLs is the only way I know of to handle a 100x spike in the load. When my LLM compared the pricing of ECS Express Mode + RDS vs Lambda + DynamoDB I realised the difference is negligible at full scale, assuming the CDN is being hit 90% of the time. Behind the CDN, the origin would cost about $1.2k a month on Lambda + DynamoDB against $0.6–0.9k on ECS + RDS. Compared to the CDN itself, which would be about $39k a month, that difference disappears. So, I decided to switch to Lambda + DynamoDB instead. Using Lambda and DynamoDB simplified the infrastructure even further and the practice deployment dropped from about $50 a month to about $0 because nothing bills while idle. I had to drop the counter, but generating a 7-character code was good enough. If clashes start happening we can just increase to 8 characters. Some consequences of switching to Lambda + DynamoDB were deeper vendor lock-in and cold starts.

[Decision record](https://github.com/curiousdirection/url-shortener/blob/main/docs/decisions/0006-move-to-lambda-and-dynamodb.md)

### No Redis cache

The final design doesn't involve Redis at all. With DynamoDB reads already taking single-digit milliseconds and assuming a 90% CDN cache hit rate it was hard to justify adding Redis (inside a VPC).

[Decision record](https://github.com/curiousdirection/url-shortener/blob/main/docs/decisions/0008-no-redis-cache.md)

### Keep one function for redirects and creates

In the end I decided against separate functions for reads and writes. While the system is a lot more read than write heavy, the CDN already separates most of the traffic so it was hard to justify the extra complexity. I could imagine the original design with long-running servers benefiting from the separation.

[Decision record](https://github.com/curiousdirection/url-shortener/blob/main/docs/decisions/0010-one-function-for-reads-and-writes.md)

## Final thoughts

Thank you for coming along for the ride. The part that I found most interesting was that the optimal solution involved not using Redis. Having a coding agent help me to iterate on the architecture, do research (e.g. pricing) and be a sparring partner is a game changer. Feel free to scrutinise the final implementation [on GitHub](https://github.com/curiousdirection/url-shortener).
