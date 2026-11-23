---
title: "Url Shortener"
type: post
date: 2026-11-23T12:57:08+01:00
excerpt: 
url: url-shortener
canonical: true
shareImage: /img/url-shortener/architecture.svg
twitterLink:
extraContent:
---

I have been brushing up on my system design skills I thought to myself "what if I just build a url shortener myself?". So I did and the result is [on GitHub](https://github.com/curiousdirection/url-shortener)! I translated the classic interview style system design question from something abstract into something concrete. With a coding agent this was feasible in a short amount of time.

<!--more-->
<!-- og:description -->

## Functional Requirements

![The web page, with a link to this article shortened to a 7-character code](/img/url-shortener/ui.png)

- A user can enter a url into a form and they are given a short url in return
- When a user accesses a short url they are redirected to the original url (eg. your-domain.com/abcd123 -> www.example.com/a/long/path)

## Assumptions

- Short codes can be guessable
- 1 billion stored URLs
- 100 million daily active users
- 1 billion redirects with spikes up to 100x when a link goes viral

## High level design

![Architecture: the client calls CloudFront, which serves the web page from S3 and calls the Lambda function, which reads and writes the urls table in DynamoDB](/img/url-shortener/architecture.svg)

### Creating a url

1. When a user enters a URL an HTTP POST request is sent to /api/urls, which is served by a Lambda function
2. The function creates a random base62 (a-Z,0-9) 7-digit code and stores it in DynamoDB
3. If the code already exists a new one is generated instead.
4. After the code is created the Lambda function returns it in the response with a 201 Created status code.
5. If the code is not found (DynamoDB defaults to being eventually consistent) a consistent read is made

### Hitting a short url

1. When a user fetches a short url (eg. your-domain.com/abcd123) a HTTP GET request is sent to /:code, which is served by a Lambda function
2. The function fetches the short code from DynamoDB and returns a 302 Found status code with the url to redirect to
3. The Cloudfront CDN caches the url for one year - they have to be manually invalidated
4. When the same short url is fetched again the cached response is served from the CDN.

## Interesting decisions

If you look at the [repo's decision records](https://github.com/curiousdirection/url-shortener/tree/main/docs/decisions) you will see how I decided on the final decision. I've listed the more interesting ones below. For each one I've linked the decision record if you are interested in more detail, which justifies each decision including consequences, alternatives and when to revisit.

### Replacing EC2 with ECS express mode

The original design had a counter, which was used to generated the short code. The idea was that you increment the counter every time a url is created. For the counter Redis was chosen. This was originally deployed with a Network Load Balancer and EC2 with auto scaling. This could have likely been a viable end solution, and it would probably be the cheapest at full scale, but it was a lot of infrastructure to manage so I switched to ECS Express mode instead . 

[Decision record](https://github.com/curiousdirection/url-shortener/blob/main/docs/decisions/0002-deploy-with-ecs-express-mode.md)

### Replacing Redis with a Postgres sequence

Another decision I made was to replace Redis with a simple Postgres sequence. It was simpler to manage and reduced the points of failure. Although I hadn't fully thought through recovery at this point, having two separate DBs that can go out of sync would have been a challenge to solve.

[Decision record](https://github.com/curiousdirection/url-shortener/blob/main/docs/decisions/0005-postgres-sequence-for-short-codes.md)

### Replacing ECS express mode and RDS with Lambda and DynamoDB

By this point I was planning to use a CDN to cache URLs. What I hadn't realised was that using a CDN to cache URLs is the only way I know of to handle a 100x spike in the load. When my LLM compared the pricing of ECS express mode + RDS vs Lambda + DynamoDB I realised the cost is negligible at full scale, assuming the CDN is being hit 90% of the time. So, I decided to switch to Lambda + DynamoDB instead . Using Lambda and DynamoDB simplified the infrastructure even further and it's almost free to run while everything is idle. I had to drop the counter, but generating a 7-digit code was good enough. If clashes start happening we can just increase to 8 digits. Some consequences of switching to Lambda + DynamoDB was deeper vendor lock-in and cold starts

[Decision record](https://github.com/curiousdirection/url-shortener/blob/main/docs/decisions/0006-move-to-lambda-and-dynamodb.md)

### No Redis cache

The final design doesn't involve Redis at all. With DynamoDB reads already taking single-digit milliseconds and assuming 90% CDN cache hit rate it was hard to justify adding Redis (behind a VPC).

[Decision record](https://github.com/curiousdirection/url-shortener/blob/main/docs/decisions/0008-no-redis-cache.md)

### Keep one function for redirects and creates

In the end I decided against separate functions for reads and writes. While the system is a lot more read than write heavy, the CDN already separates most of the traffic so it was hard to justify the extra complexity. I could imagine the original design with long running servers benefiting from the separation

[Decision record](https://github.com/curiousdirection/url-shortener/blob/main/docs/decisions/0010-one-function-for-reads-and-writes.md)

## Final thoughts

Thank you for coming along for the ride. The part that I found most interesting was that the optimal solution involved not using Redis. Feel free to scrutinise that final implementation [on GitHub](https://github.com/curiousdirection/url-shortener).


