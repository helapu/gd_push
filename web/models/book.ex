defmodule GdPush.Book do
  use GdPush.Web, :model

  schema "books" do
    field :name, :string
    field :author, :string
    field :publish_date, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :author, :publish_date])
    |> validate_required([:name, :author, :publish_date])
  end
end
