defmodule Lifecycle.Timeline.Phase do
  @moduledoc """
    Schema table for Phase Objects
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Lifecycle.Bridge.Phasor
  alias Lifecycle.Timeline.Phase
  alias Lifecycle.Users.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "phases" do
    field :content, :string
    field :title, :string
    field :type, :string
    # field :parent, :binary_id
    # field :child, :binary_id
    has_many :echoes, Lifecycle.Timeline.Echo, foreign_key: :phase_id
    many_to_many :child, Phase, join_through: Phasor, join_keys: [parent_id: :id, child_id: :id]
    many_to_many :parent, Phase, join_through: Phasor, join_keys: [child_id: :id, parent_id: :id]

    many_to_many :users, User, join_through: "phase_user_link"
    # many_to_many :child, Lifecycle.Bridge.Phase, join_through: "phase_phase_link"

    timestamps()
  end

  @doc false
  def changeset(phase, attrs) do
    phase
    |> cast(attrs, [:content, :title, :type])
    #|> cast_assoc(:parent)
    |> validate_required([:content, :title, :type])
  end
end
