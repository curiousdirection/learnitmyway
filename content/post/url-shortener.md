---
title: "Building a URL shortener: what the system design interview leaves out"
type: post
date: 2026-11-23
draft: true
excerpt: In this article, I explain the design of a URL shortener I built and share the things the classic system design interview tends to leave out.
url: url-shortener
canonical: true
shareImage: /img/url-shortener/architecture.svg
twitterLink:
extraContent:
---

The URL shortener is a classic system design interview question. I recently [built one](https://github.com/curiousdirection/url-shortener). In this article, I explain the design and share the things I learned that the interview answer tends to leave out.

<!--more-->
<!-- og:description -->

## What I built

- One sentence on what it does: give it a long URL (and optionally an alias) and get a short one back.
- The stack: Node, TypeScript and Hono, running on Lambda, with the links in DynamoDB and CloudFront in front.
- It's a design exercise: sized for the scale below but running on free or nearly free infrastructure.

## The assumptions

- 1 billion stored links, 100 million daily users.
- About 1 billion redirects and 10 million new links a day (11,600 and 115 per second on average).
- Spikes of up to 100 times that, without warning, when a link goes viral.
- Takeaway: it's a read-heavy system, and the spikes matter more than the averages.

## The design

- Architecture diagram (copy `docs/architecture.svg` from the url-shortener repo).
- **Creating a link:** generate a random 7-character code and write it only if it's free. A taken alias returns `409`.
- **Following a link:** CloudFront answers from its cache. On a miss, the function reads the table by code and returns a `302`.
- Keep this section short. The interesting parts are in the next one.

## Where it differs from the interview answer

### Short codes: no counter

- Interview answer: a global counter, a key generation service or ZooKeeper handing out ranges.
- What I did: started with a Redis counter, moved to a Postgres sequence (one less service on the create path), then dropped the counter entirely.
- Random 7-character codes, written only if free. 62^7 is about 3.5 trillion codes, so at 1 billion links a draw is taken about 1 in 3,500 times. Five misses in a row would happen about once every 150 million years.
- Lesson: the counter solves a problem you only have if you insist on the shortest possible codes.

### Caching: no Redis

- Interview answer: put Redis in front of the database.
- What I did: CloudFront is the only cache. The function only sees cache misses, which are mostly links nobody has asked for recently, so a second cache would rarely get a hit.
- Redis would also cost money while idle and need a private network.

### 301 or 302

- Interview answer: debate 301 (cached by the browser, fewer requests) against 302 (every click reaches you, better for analytics).
- What I did: a `302` for the browser, but CloudFront caches it for a year (`s-maxage`). The browser keeps nothing, so taking a link down only needs a cache invalidation.
- Lesson: you can choose who caches, not just whether.

### Spikes: more servers don't help

- Interview answer: add more servers behind a load balancer.
- What I learned: neither containers nor Lambda scale fast enough for a sudden 100 times spike. New containers take minutes. Lambda adds at most 1,000 copies every 10 seconds, and DynamoDB limits how fast one key can be read.
- The edge cache is what absorbs a viral link, not the servers.

### A new link should never return "not found"

- DynamoDB reads are eventually consistent by default, so a link created a moment ago could return `404`.
- Fix: on a miss, read again with a strongly consistent read. Only misses pay for it.
- Rarely mentioned in interviews, but it's the first thing a real user would notice.

### Abuse and cost

- Popular links survive a flood because they're cached, and a per-address rate limit catches a single sender.
- A flood of made-up codes from many addresses misses the cache every time and goes straight to the function.
- Nothing caps what CloudFront and the firewall charge per request, blocked requests included.
- Lesson: at this scale, cost is part of the design. CloudFront at full scale is about $36,500 a month, far more than the function and database behind it.

## What I learned along the way

- **From servers to Lambda:** started on servers with Postgres, then containers (about $50 a month for practice), then Lambda and DynamoDB (about $0). Nothing bills while idle.
- **Behind a cache, the cheap option and the scalable option are the same.** Without one, Lambda at full scale would cost about twice the container setup.
- **The account shaped the design.** A Free plan account blocks some features (e.g. signing in from GitHub without stored keys), so deploys ended up running on a CodeBuild runner with no access keys at all.
- **Writing decision records as I went** made it easy to change my mind and see why I'd made each choice. Eleven of them, several superseding earlier ones.
- Possibly a follow-up article on the deployment story.

## Final thoughts

- The interview answer is a good starting point, but the interesting decisions come from real constraints: cost, spikes, consistency and abuse.
- Link to the repo and the decision records for anyone who wants the details.

_Disclaimer: Parts of this article were drafted with the help of an AI assistant. The project, the experience and the opinions are my own._
