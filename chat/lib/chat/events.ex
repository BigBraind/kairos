defmodule Chat.Events do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:eventID, :binary_id, autogenerate: true}

  schema "events" do
    field :event_type, :integer
    field :userID, :string

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:eventID, :event_type, :userID])
    |> validate_required([:eventID, :event_type, :userID])
  end

end
