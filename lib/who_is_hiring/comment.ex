defmodule WhoIsHiring.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field(:hacker_news_id, :integer)
    field(:time, :integer)
    field(:text, :string)
    field(:notified_at, :utc_datetime)

    timestamps()
  end

  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:hacker_news_id, :time, :text])
    |> validate_required([:hacker_news_id, :time, :text])
  end
end
