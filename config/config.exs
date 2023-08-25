import Config

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :who_is_hiring, :telegramer,
  token: System.get_env("TELEGRAM_TOKEN"),
  channel_id: System.get_env("TELEGRAM_CHANNEL_ID")

config :who_is_hiring, :notifier,
  parent_post:
    System.get_env("HN_PARENT_POST") ||
      raise("""
      You must set the environment variable HN_PARENT_POST
      as the id of the Hacker News parent post.
      """)

config :who_is_hiring, :notifier,
  techs_of_interest:
    System.get_env("TECHS_OF_INTEREST") ||
      raise("""
      You must set the environment variable TECHS_OF_INTEREST
      as a comma separated list of technologies you are interested in.
      TECHS_OF_INTEREST="elixir,erlang,phoenix"
      """)

config :who_is_hiring,
  ecto_repos: [WhoIsHiring.Repo]

import_config "#{config_env()}.exs"
