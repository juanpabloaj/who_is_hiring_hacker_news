defmodule WhoIsHiring do
  @moduledoc """
  Documentation for `WhoIsHiring`.
  """
  require Logger

  alias WhoIsHiring.HackerNewsClient
  alias WhoIsHiring.{Comment, Story}

  @doc """
  Fetches the jobs from the Hacker News thread with the given `parent_item_id` filtering by `langs_of_interest`.

  ## Examples

      iex> WhoIsHiring.fetch_jobs(123456, ["elixir", "erlang"])
      {:ok, [
        %{"text" => "Elixir is a functional, concurrent, general-purpose programming language that runs on the Erlang VM. ...", "id" => 123456, "time" => 123456},
        %{"text" => "Erlang is a programming language used to build massively scalable soft real-time systems with requirements on high availability. ...", "id" => 123456, "time" => 123456}
      ]}

  """
  def fetch_jobs(parent_item_id, langs_of_interest) do
    {:ok, child_ids} = HackerNewsClient.get_child_ids(parent_item_id)

    child_ids
    |> Task.async_stream(&HackerNewsClient.get_child_item/1,
      max_concurrency: HackerNewsClient.pool_size()
    )
    |> Enum.reduce([], fn {:ok, %{} = m}, acc ->
      [m | acc]
    end)
    |> Enum.filter(fn %{"text" => text} ->
      Enum.any?(langs_of_interest, &String.contains?(text, &1))
    end)
    |> Enum.sort_by(& &1["time"])
  end

  def pull_story(parent_item_id) do
    story = HackerNewsClient.get_item_info(parent_item_id)

    %Story{
      hacker_news_id: story["id"],
      title: story["title"],
      time: story["time"]
    }
    |> WhoIsHiring.Repo.insert(on_conflict: :nothing)
  end

  def pull_jobs(parent_item_id, langs_of_interest) do
    fetch_jobs(parent_item_id, langs_of_interest)
    |> Enum.map(fn %{"text" => text, "id" => id, "time" => time} ->
      %Comment{
        hacker_news_id: id,
        text: text,
        time: time
      }
    end)
    |> Enum.each(&WhoIsHiring.Repo.insert(&1, on_conflict: :nothing))
  end

  def generate_report(parent_item_id, langs_of_interest \\ ["elixir"]) do
    fetch_jobs(parent_item_id, langs_of_interest)
    |> print_results()
  end

  def print_results(results) do
    results
    |> Enum.each(fn %{"text" => text, "id" => id, "time" => time} ->
      first_letters = String.slice(text, 0, 60)
      date = DateTime.from_unix!(time)

      IO.puts("#{date} #{first_letters}... https://news.ycombinator.com/item?id=#{id}")
    end)
  end
end
