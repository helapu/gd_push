defmodule GdPush.Repo.Migrations.CreateDevice do
  use Ecto.Migration

  def change do
    create table(:devices) do
      add :uid, :string
      add :nickname, :string
      add :token, :string
      add :platform, :string
      add :extra, :string

      timestamps()
    end

  end
end
