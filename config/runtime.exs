import Config

if config_env() == :prod do
  database_path =
    System.get_env("DATABASE_PATH") ||
      raise """
      DATABASE_PATH environment variable is missing.
      For example: /data/name/name.db
      """

  config :who_is_hiring, WhoIsHiring.Repo,
    database: database_path,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

  config :who_is_hiring, :telegramer,
    token: System.get_env("TELEGRAM_TOKEN"),
    channel_id: System.get_env("TELEGRAM_CHANNEL_ID")

  config :who_is_hiring, :notifier,
    parent_post:
      System.get_env("HN_PARENT_POST") ||
        raise("""
        You must set the environment variable HN_PARENT_POST
        as the id of the Hacker News parent post.
        """),
    techs_of_interest:
      System.get_env("TECHS_OF_INTEREST") ||
        raise("""
        You must set the environment variable TECHS_OF_INTEREST
        as a comma separated list of technologies you are interested in.
        TECHS_OF_INTEREST="elixir,erlang,phoenix"
        """)
end
