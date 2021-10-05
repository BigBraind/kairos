defmodule Chat.Journey do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  @primary_key {:uuid, :binary_id, autogenerate: true}
  schema "journey" do
    field :name, :string
    field :type, :string
    timestamps()
  end

  @doc false
  def changeset(echo, attrs) do
    echo
    |> cast(attrs, [:type, :name])
    |> validate_required([:type, :name ])
  end

  def recall(limit \\ 8) do
    Chat.Repo.all(Chat.Echo, limit: limit)
  end

  # def call(limit \\ 8, name) do
  #   Chat.Repo.all(Chat.Echo, limit: limit)
  # end
end
