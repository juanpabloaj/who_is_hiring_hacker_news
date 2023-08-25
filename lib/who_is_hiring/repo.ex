defmodule WhoIsHiring.Repo do
  use Ecto.Repo, otp_app: :who_is_hiring, adapter: Ecto.Adapters.SQLite3
end
