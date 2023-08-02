# WhoIsHiring

It checks Hacker News Firebase API looking for elixir jobs.

It is strongly based on https://blog.appsignal.com/2020/07/28/the-state-of-elixir-http-clients.html

## Usage

Looking for job posts with the word elixir. It requires the parent post id, for example, the post id of "Ask HN: Who is hiring? (August 2023)", (https://news.ycombinator.com/item?id=36956867).

    WhoIsHiring.generate_report("36956867")

    https://news.ycombinator.com/item?id=36960439 Ockam | Remote (some US only, others global) | We make tools...
    https://news.ycombinator.com/item?id=36963079 Nightwatch.io | 100% Remote | Full-time &amp; Part-time<p>Cu...
    https://news.ycombinator.com/item?id=36957964 HamiltonPractice, REMOTE, INTERNS, ~1000$ pm, 3 months<p>Ham...

Looking for job posts with other words

    WhoIsHiring.generate_report("36956867", ["elixir", "golang"])
