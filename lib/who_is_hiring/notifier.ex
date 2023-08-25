defmodule WhoIsHiring.Notifier do
  use GenServer

  require Logger

  alias WhoIsHiring.Repo

  @doc """
    It is a simple way to send the request to the HN API periodically.
  """

  @time_request 12 * 60 * 60_000

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(state) do
    Process.send_after(self(), :request_jobs, 0)
    {:ok, state}
  end

  def handle_info(:request_jobs, state) do
    Logger.info("Requesting jobs to HN API")

    parent_post =
      Application.get_env(:who_is_hiring, :notifier)[:parent_post]
      |> String.to_integer()

    techs =
      Application.get_env(:who_is_hiring, :notifier)[:techs_of_interest]
      |> :string.split(",")

    WhoIsHiring.pull_jobs(parent_post, techs)

    Repo.unnotified_comments()
    |> Enum.each(fn comment ->
      create_message(comment)
      |> WhoIsHiring.Telegramer.send_message()

      Repo.mark_comment_as_notified(comment)
    end)

    Process.send_after(self(), :request_jobs, @time_request)
    {:noreply, state}
  end

  def create_message(comment) do
    first_letters = String.slice(comment.text, 0, 140)
    id = comment.hacker_news_id

    "#{first_letters}... https://news.ycombinator.com/item?id=#{id}"
  end
end
