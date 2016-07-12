defmodule GdPush.Device do
  use GdPush.Web, :model

  schema "devices" do
    field :uid, :string
    field :nickname, :string
    field :token, :string
    field :platform, :string
    field :extra, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:uid, :nickname, :token, :platform, :extra])
    |> validate_required([:uid])
  end
end
