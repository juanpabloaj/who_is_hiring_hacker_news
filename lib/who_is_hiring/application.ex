defmodule WhoIsHiring.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    base_children = [
      WhoIsHiring.HackerNewsClient.child_spec()
    ]

    token = Application.get_env(:who_is_hiring, :telegramer)[:token]
    channel_id = Application.get_env(:who_is_hiring, :telegramer)[:channel_id]
    parent_post = Application.get_env(:who_is_hiring, :notifier)[:parent_post]
    techs = Application.get_env(:who_is_hiring, :notifier)[:techs_of_interest]

    notifier_available =
      [token, channel_id, parent_post, techs]
      |> Enum.all?(fn x -> not is_nil(x) end)

    notifier_children =
      if notifier_available do
        [
          {WhoIsHiring.Repo, []},
          WhoIsHiring.TelegramClient.child_spec(),
          {WhoIsHiring.Telegramer, token: token, channel_id: channel_id},
          {WhoIsHiring.Notifier, parent_post: parent_post, techs_of_interest: techs}
        ]
      else
        []
      end

    children = base_children ++ notifier_children

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: WhoIsHiring.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
