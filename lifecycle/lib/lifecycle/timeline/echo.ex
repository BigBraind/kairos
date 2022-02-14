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
    field :name, :string
    field :type, :string
    field :transited, :boolean
    field :transiter, :string
    belongs_to :phase, Lifecycle.Timeline.Phase, foreign_key: :phase_id
    timestamps()
  end

  @doc false
  def changeset(echo, attrs \\ %{}) do
    echo
    |> cast(attrs, [:message, :phase_id, :type, :name, :transited, :transiter])
    # |> cast_assoc(attrs, [:journey])

    |> validate_required([:message, :name, :phase_id])
    # |> validate_required([:message, :journey, :type, :name])
  end
end
