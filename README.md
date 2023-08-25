# WhoIsHiring

It checks Hacker News Firebase API looking for elixir jobs.

It is strongly based on https://blog.appsignal.com/2020/07/28/the-state-of-elixir-http-clients.html

## Usage

Define environment variables

    DATABASE_PATH
    TELEGRAM_TOKEN
    TELEGRAM_CHANNEL_ID
    TECHS_OF_INTEREST="Elixir,Erlang"
    HN_PARENT_POST=36956867

You can get the `TELEGRAM_TOKEN` from telegram [BotFather](https://core.telegram.org/bots/tutorial#obtain-your-bot-token).

Create the database and migrate

    mix ecto.create
    mix ecto.migrate

Looking for job posts with the word elixir. It requires the parent post id, for example, the post id of "Ask HN: Who is hiring? (August 2023)", (https://news.ycombinator.com/item?id=36956867).

    WhoIsHiring.generate_report("36956867")

    2023-08-01 18:40:02Z Ockam | Remote (some US only, others global) | We make tools... https://news.ycombinator.com/item?id=36960439
    2023-08-01 21:15:32Z Nightwatch.io | 100% Remote | Full-time &amp; Part-time<p>Cu... https://news.ycombinator.com/item?id=36963079
    2023-08-03 20:18:57Z CareCar | USA | Web Backend Engineer | Remote US only<p>Care... https://news.ycombinator.com/item?id=36991211

Looking for job posts with other words

    WhoIsHiring.generate_report("36956867", ["elixir", "golang"])
