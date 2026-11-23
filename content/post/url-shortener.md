---
title: "Building a URL shortener: what the system design interview leaves out"
type: post
date: 2026-11-23
draft: true
excerpt: In this article, I explain the design of a URL shortener I built and share the things the classic system design interview tends to leave out.
url: url-shortener
canonical: true
shareImage:
twitterLink:
extraContent:
---

The URL shortener is a classic system design interview question. I recently [built one](https://github.com/curiousdirection/url-shortener). In this article, I explain the design and share the things I learned that the interview answer tends to leave out.

<!--more-->
<!-- og:description -->

- Possibly: say I've mostly worked on the frontend, so I built this to learn backend design properly.

## What I built

- One sentence on what it does: give it a long URL (and optionally an alias) and get a short one back.
- The stack: Node, TypeScript and Hono, running on Lambda, with the links in DynamoDB and CloudFront in front.
- It's a design exercise: sized for the scale below but running on free or nearly free infrastructure.

## The assumptions

- 1 billion stored links, 100 million daily users.
- About 1 billion redirects and 10 million new links a day (11,600 and 115 per second on average).
- Spikes of up to 100 times that, without warning, when a link goes viral.
- It's a read-heavy system, and the spikes matter more than the averages.
- Nothing ran at full scale. The figures in this article come from the AWS docs and pricing, and the 90% cache hit rate is a guess.

## The design

![Architecture: the client calls CloudFront, which serves the web page from S3 and calls the Lambda function, which reads and writes the urls table in DynamoDB](/img/url-shortener/architecture.svg)

- **Creating a link:** generate a random 7-character code and write it only if it's free. A taken alias returns `409`.
- **Following a link:** CloudFront answers from its cache. On a miss, the function reads the table by code and returns a `302`.
- **Caching the redirect:** the `302` tells CloudFront to keep it for a year but the browser to keep nothing, so taking a link down only needs a cache invalidation.
- **Reading a new link:** DynamoDB reads can be slightly stale, so a miss is read again with a strongly consistent read. A link created a moment ago never returns `404`, and only misses pay for the second read.

## Where I went beyond the textbook answer

### Short codes: from a counter to random codes

- Constraint: every code must be unique, and creating a link should depend on as few services as possible.
- The path: a Redis counter, then a Postgres sequence (one less service on the create path), then no counter at all once the links moved to DynamoDB.
- Choice: random 7-character codes, written only if free. 62^7 is about 3.5 trillion codes, so at 1 billion links a draw is taken about 1 in 3,500 times. Five misses in a row would happen about once every 150 million years.
- Trade-off: one character longer than a counter would need at 1 billion links, and the occasional retry.

### Caching: no Redis behind CloudFront

- Constraint: the function only sees CloudFront's cache misses, which are mostly links nobody has asked for recently.
- Choice: CloudFront is the only cache. A second cache would rarely get a hit, would cost money while idle and would need a private network.
- Revisit if the real hit rate is far below 90% and DynamoDB reads get expensive.

### Spikes: the cache isn't optional

- Constraint: a 100 times spike arrives without warning, and nothing behind the cache scales that fast. New containers take minutes. Lambda adds at most 1,000 copies every 10 seconds, and DynamoDB limits how fast one key can be read.
- Choice: compare the options behind the cache, not without it. Behind CloudFront, Lambda and DynamoDB cost about the same as containers and Postgres at full scale, and about $0 instead of $50 a month for practice.

### Abuse and cost

- Popular links survive a flood because they're cached, and a per-address rate limit catches a single sender.
- A flood of made-up codes from many addresses misses the cache every time and goes straight to the function.
- Nothing caps what CloudFront and the firewall charge per request, blocked requests included.
- At full scale, CloudFront is about $36,500 a month, far more than the function and database behind it.

## What I learned along the way

- **From servers to Lambda:** started on servers with Postgres, then containers, then Lambda and DynamoDB. Nothing bills while idle.
- **The account shaped the design.** A Free plan account blocks some features (e.g. signing in from GitHub without stored keys), so deploys ended up running on a CodeBuild runner with no access keys at all.
- **Writing decision records as I went** made it easy to change my mind and see why I'd made each choice. Eleven of them, several superseding earlier ones.
- Possibly a follow-up article on the deployment story.

## Final thoughts

- The interview answer is a good starting point, but the interesting decisions come from real constraints: cost, spikes and abuse.
- Link to the repo and the decision records for anyone who wants the details.

_Disclaimer: Parts of this article were drafted with the help of an AI assistant. The project, the experience and the opinions are my own._
