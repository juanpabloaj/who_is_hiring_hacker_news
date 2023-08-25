import Config

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :who_is_hiring, :telegramer,
  token: System.get_env("TELEGRAM_TOKEN"),
  channel_id: System.get_env("TELEGRAM_CHANNEL_ID")

config :who_is_hiring, :notifier,
  parent_post: System.get_env("HN_PARENT_POST"),
  techs_of_interest: System.get_env("TECHS_OF_INTEREST")

config :who_is_hiring,
  ecto_repos: [WhoIsHiring.Repo]

import_config "#{config_env()}.exs"
