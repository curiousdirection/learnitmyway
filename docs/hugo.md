# Hugo

Version pinned in `mise.toml` and `netlify.toml` (0.147.9).

- `.ReadingTime` returns the estimated minutes to read a page's content (212 words per minute by default), used in the post header. Source: [Hugo – ReadingTime](https://gohugo.io/methods/page/readingtime/)
- `.GroupByDate "2006"` groups a page collection by year in descending order, used for the year sections on the home page. Each group has `.Key` and `.Pages`. Source: [Hugo – GroupByDate](https://gohugo.io/methods/pages/groupbydate/)
- `where .Site.RegularPages "Section" "in" $mainSections` selects the posts. Source: [Hugo – where](https://gohugo.io/functions/collections/where/)
