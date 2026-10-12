---
title: "My first impressions of n8n"
type: post
date: 2026-10-12
excerpt: In this article, I share my first impressions of n8n after building a workflow with it in a few hours.
url: n8n-first-impressions
canonical: true
shareImage: /img/n8n/step-3.webp
twitterLink:
extraContent:
---

I recently tried [n8n](https://n8n.io/) for the first time and was surprised how quickly it became useful. In this article, I share my first impressions after building a workflow with it in a few hours.

<!--more-->
<!-- og:description -->

## What I built

The idea was simple. Read the Hacker News jobs feed, find certain roles (e.g. software engineer) in a given location (San Francisco) or remote, rank them by salary and post a digest to Slack. I built it in three versions, each taking less than an hour.

This is what the digest looks like:

![The job digest posted to Slack](/img/n8n/slack-digest.png)

## Useful within an hour

![The first version of the workflow](/img/n8n/step-1.webp)

The first version reads the feed, uses an OpenAI model to extract the role, location and salary from each posting, filters for the target roles and posts a ranked digest to Slack. Out of 20 postings, it found 4 matches.

I was amazed how quickly the product was useful. I didn't read any docs, I didn't set up any infrastructure and I didn't write any code. Instead, I used agent mode, n8n's AI assistant that builds workflows from a description, and had something running in no time.

## Agent mode did the heavy lifting

Most of the workflow was built with agent mode. I described what I wanted, it added the nodes and connected them, and I tweaked things by hand. For example, I changed the location and removed a step that recorded which postings had already been parsed.

![The second version of the workflow with an AI agent](/img/n8n/step-2.webp)

In the second version, I asked it to turn the extraction step into an agent with a tool that can fetch the job page. A lot of postings had missing data, so being able to read the job ad resulted in better data. Not only that, but the number of matches went from 4 to 9!

![The third version of the workflow that saves chosen roles](/img/n8n/step-3.webp)

In the third version, I added a human in the loop. After the digest is posted, Slack asks me which roles I want to save and the chosen roles are upserted into a `saved_jobs` table.

## The free plan goes a long way

Everything I built fit within the free plan. It comes with some agent credits for building workflows with agent mode and some LLM credits for running them, so I could try out the AI features for free.

## Supporting a European company

n8n is based in Berlin. The US dominates so much of the software I use every day, especially when it comes to AI, so I like the idea of supporting a European company that can compete. It's nice to see a product from Europe that is this polished.

## Next steps

There are a few things that could improve the workflow:

- **A cron job**: At the moment I run the workflow manually. A schedule trigger would mean the digest arrives every morning without me thinking about it.
- **Keep track of what has already been sent**: I removed this step to keep things simple while I was iterating, but without it the same postings appear in every digest.
- **Do something with saved jobs**: Right now the saved jobs just sit in a table. I could add another step where an agent looks up more details about each company (e.g. tech stack, funding and financial health).

## Final thoughts

I went from nothing to a workflow that was useful in a few hours. Agent mode was very helpful, the free plan was more than enough and it's nice to support a European company while doing it. If you have a repetitive task that involves a few different services, I would recommend giving n8n a try.

_Disclaimer: Parts of this article were drafted with the help of Claude, an AI assistant. The workflow, the experience and the opinions are my own._
