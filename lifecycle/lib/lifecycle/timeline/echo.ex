defmodule Lifecycle.Timeline.Echo do
  @moduledoc """
    Schema table for Echo objects.
    Echo => Chat message
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "echoes" do
    field :message, :string
    belongs_to :poster, Lifecycle.Users.User, foreign_key: :poster_id
    field :type, :string
    belongs_to :phase, Lifecycle.Timeline.Phase, foreign_key: :phase_id
    timestamps()
  end

  @doc false
  def changeset(echo, attrs \\ %{}) do
    echo
    |> cast(attrs, [:message, :phase_id, :type, :poster_id])
    |> validate_required([:message, :poster_id, :phase_id])
  end
end
