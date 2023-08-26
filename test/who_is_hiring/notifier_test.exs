defmodule WhoIsHiring.NotifierTest do
  use ExUnit.Case
  alias WhoIsHiring.Notifier

  test "requesting_log_msg" do
    assert Notifier.requesting_log_msg(101, ["Elixir", "Golang"]) ==
             "Requesting jobs to HN API, post 101 filter by Elixir,Golang"
  end

  test "requesting_log_msg, empty list" do
    assert Notifier.requesting_log_msg(101, []) ==
             "Requesting jobs to HN API, post 101 filter by "
  end
end
