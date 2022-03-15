defmodule Lifecycle.Users.Journey do
  @moduledoc """
    Schema table for Phase Objects
  """
  use Ecto.Schema
  import Ecto.Changeset
  # alias Lifecycle.Bridge.Journeyer
  alias Lifecycle.Timeline.Transition

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "journeys" do
    belongs_to :party, Lifecycle.Users.Party, foreign_key: :party_id
    has_many :transitions, Transition, foreign_key: :journey_id
    # belongs_to :realm, Lifecycle.Orgs.Realm

    timestamps()
  end

  @doc false
  def changeset(journey, attrs) do
    journey
    |> cast(attrs, [:party_id])
    |> validate_required([:party_id])
  end
end
