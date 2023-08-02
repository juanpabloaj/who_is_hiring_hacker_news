defmodule WhoIsHiring do
  @moduledoc """
  Documentation for `WhoIsHiring`.
  """
  require Logger

  alias WhoIsHiring.HackerNewsClient

  def generate_report(parent_item_id, langs_of_interest \\ ["elixir"]) do
    {:ok, child_ids} = HackerNewsClient.get_child_ids(parent_item_id)

    child_ids
    |> Task.async_stream(&HackerNewsClient.get_child_item/1,
      max_concurrency: HackerNewsClient.pool_size()
    )
    |> Enum.reduce([], fn {:ok, %{} = m}, acc ->
      [m | acc]
    end)
    |> Enum.filter(fn %{"text" => text} ->
      Enum.any?(langs_of_interest, &String.contains?(String.downcase(text), &1))
    end)
    |> print_results()
  end

  def print_results(results) do
    results
    |> Enum.each(fn %{"text" => text, "id" => id} ->
      first_letters = String.slice(text, 0, 60)
      IO.puts("https://news.ycombinator.com/item?id=#{id} #{first_letters}...")
    end)
  end
end
