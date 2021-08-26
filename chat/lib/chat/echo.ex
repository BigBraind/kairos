defmodule Chat.Echo do
  use Ecto.Schema
  import Ecto.Changeset

  schema "echo" do
    field :lobby, :string
    field :message, :string
    field :name, :string
    field :type, :string

    timestamps()
  end

  @doc false
  def changeset(echo, attrs) do
    echo
    |> cast(attrs, [:type, :lobby, :name, :message])
    |> validate_required([:type, :lobby, :name, :message])
  end

  def recall(limit \\ 8) do
    Chat.Repo.all(Chat.Echo, limit: limit)
  end
end
