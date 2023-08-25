defmodule WhoIsHiring.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
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
