defmodule Chat.Echo do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "echo" do
    field :journey, :string
    field :message, :string
    field :name, :string
    field :type, :string

    timestamps()
  end

  @doc false
  def changeset(echo, attrs) do
    echo
    |> cast(attrs, [:type, :journey, :name, :message])
    |> validate_required([:type, :journey, :name, :message])
  end

  def recall(limit \\ 8) do
    Chat.Repo.all(Chat.Echo, limit: limit)
  end

  def journey_call(journey) do
    query=from(Chat.Echo, where: [journey: ^journey])
    Chat.Repo.all(query, limit: 8)
  end
end
