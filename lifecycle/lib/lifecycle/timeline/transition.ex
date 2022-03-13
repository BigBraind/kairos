defmodule Lifecycle.Timeline.Transition do
  @moduledoc """
    Schema table for Phase Objects
  """
  use Ecto.Schema
  import Ecto.Changeset
  # alias Lifecycle.Timeline.Phase
  # alias Lifecycle.Users.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "transitions" do
    belongs_to :initiator, Lifecycle.Users.User, foreign_key: :initiator_id
    belongs_to :phase, Lifecycle.Timeline.Phase, foreign_key: :phase_id
    belongs_to :journey, Lifecycle.Timeline.Journey, foreign_key: :journey_id
    field :transited, :boolean, default: false
    belongs_to :transiter, Lifecycle.Users.User, foreign_key: :transiter_id
    field :answers, :map
    timestamps()
  end

  @doc false
  def changeset(transition, attrs) do
    transition
    |> cast(attrs, [:transited, :transiter_id, :answers, :phase_id, :initiator_id, :journey_id])
  end
end
