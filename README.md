# WhoIsHiring

It scans the Hacker News Firebase API for jobs of interest.

The Hacker news client is based on the article https://blog.appsignal.com/2020/07/28/the-state-of-elixir-http-clients.html

## Usage

Looking for job posts with the word elixir. It requires the parent post id, for example, the post id of "Ask HN: Who is hiring? (August 2023)", (https://news.ycombinator.com/item?id=36956867).

    WhoIsHiring.generate_report("36956867")

    2023-08-01 18:40:02Z Ockam | Remote (some US only, others global) | We make tools... https://news.ycombinator.com/item?id=36960439
    2023-08-01 21:15:32Z Nightwatch.io | 100% Remote | Full-time &amp; Part-time<p>Cu... https://news.ycombinator.com/item?id=36963079
    2023-08-03 20:18:57Z CareCar | USA | Web Backend Engineer | Remote US only<p>Care... https://news.ycombinator.com/item?id=36991211

Looking for job posts with other words

    WhoIsHiring.generate_report("36956867", ["Elixir", "Golang"])

## Notification mode

When the necessary environment variables are set, the module will periodically check the Hacker News post. If it detects a comment mentioning any of your specified technologies of interest, you'll receive a notification on Telegram with a brief overview and a link to the job description.

The system uses an SQLite table to track notifications, ensuring you don't receive the same alert twice. Migrations are applied upon app startup.

To prevent spamming the Telegram API, the system throttles its messages, sending one every second. See lib/who_is_hiring/telegramer.ex for more details.

Set and export the environment variables:

    DATABASE_PATH
    TELEGRAM_TOKEN
    TELEGRAM_CHANNEL_ID
    TECHS_OF_INTEREST="Elixir,Erlang"
    HN_PARENT_POST=36956867

You can get the `TELEGRAM_TOKEN` from telegram [BotFather](https://core.telegram.org/bots/tutorial#obtain-your-bot-token).

Start mix

    TECHS_OF_INTEREST="Elixir,Golang" \
    HN_PARENT_POST=36956867 \
    mix run --no-halt

## Release

Build a release

    MIX_ENV=prod mix release who_is_hiring

Build a [Burrito](https://github.com/burrito-elixir/burrito) binary

    MIX_ENV=prod mix release who_is_hiring_burrito
