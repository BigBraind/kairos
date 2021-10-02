defmodule Chat.MessageDrop do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:eventID, :binary_id, autogenerate: true}

  schema "message_drop" do
    field :lobbyID, :integer
    field :message, :string
    field :image, :string

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:eventID, :lobbyID, :message, :image])
    |> validate_required([:eventID, :lobbyID, :message, :image])
  end

end
