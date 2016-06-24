defmodule GdPush.Repo.Migrations.CreateBook do
  use Ecto.Migration

  def change do
    create table(:books) do
      add :name, :string
      add :author, :string
      add :publish_date, :string

      timestamps()
    end

  end
end
