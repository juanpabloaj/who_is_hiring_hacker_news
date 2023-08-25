import Config

config :who_is_hiring, WhoIsHiring.Repo,
  database: Path.expand("../who_is_hiring_dev.db", Path.dirname(__ENV__.file)),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")
