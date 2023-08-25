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
end
