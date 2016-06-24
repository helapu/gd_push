defmodule GdPush.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string
      add :number_of_pets, :integer

      timestamps()
    end

  end
end
