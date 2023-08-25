defmodule WhoIsHiring.Repo do
  use Ecto.Repo, otp_app: :who_is_hiring, adapter: Ecto.Adapters.SQLite3

  import Ecto.Query

  alias WhoIsHiring.{Story, Comment}

  def latest_story_id() do
    from(s in Story, order_by: [desc: s.time], limit: 1)
    |> one()
    |> Map.get(:hacker_news_id)
  end

  def unnotified_comments do
    from(c in Comment, where: is_nil(c.notified_at), order_by: [asc: c.time])
    |> all()
  end

  def mark_comment_as_notified(comment) do
    comment
    |> Ecto.Changeset.change(%{notified_at: DateTime.truncate(DateTime.utc_now(), :second)})
    |> update()
  end
end
