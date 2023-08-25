import Config

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :who_is_hiring,
  ecto_repos: [WhoIsHiring.Repo]

import_config "#{config_env()}.exs"
