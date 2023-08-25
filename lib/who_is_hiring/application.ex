defmodule WhoIsHiring.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {WhoIsHiring.Repo, []},
      WhoIsHiring.HackerNewsClient.child_spec(),
      WhoIsHiring.TelegramClient.child_spec(),
      WhoIsHiring.Telegramer,
      WhoIsHiring.Notifier
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: WhoIsHiring.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
