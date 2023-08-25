defmodule WhoIsHiring.Story do
  use Ecto.Schema
  import Ecto.Changeset

  schema "stories" do
    field(:hacker_news_id, :integer)
    field(:title, :string)
    field(:time, :integer)

    timestamps()
  end

  def changeset(story, attrs) do
    story
    |> cast(attrs, [:hacker_news_id, :title, :time])
    |> validate_required([:hacker_news_id, :title, :time])
  end
end
