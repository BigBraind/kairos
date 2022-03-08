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
    belongs_to :user, Lifecycle.Users.User, foreign_key: :user_name, type: :string
    field :type, :string
    belongs_to :phase, Lifecycle.Timeline.Phase, foreign_key: :phase_id
    timestamps()
  end

  @doc false
  def changeset(echo, attrs \\ %{}) do
    echo
    |> cast(attrs, [:message, :phase_id, :type, :user_name])
    |> validate_required([:message, :phase_id, :user_name])
  end
end
