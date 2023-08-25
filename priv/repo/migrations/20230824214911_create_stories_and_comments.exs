defmodule WhoIsHiring.Repo.Migrations.CreateStoriesAndComments do
  use Ecto.Migration

  def change do
    create table(:stories) do
      add(:hacker_news_id, :integer, null: false)
      add(:title, :string, null: false)
      add(:time, :integer, null: false)

      timestamps()
    end

    create(unique_index(:stories, [:hacker_news_id]))

    create table(:comments) do
      add(:hacker_news_id, :integer, null: false)
      add(:time, :integer, null: false)
      add(:text, :string, null: false)
      add(:notified_at, :utc_datetime)

      timestamps()
    end

    create(unique_index(:comments, [:hacker_news_id]))
  end
end
