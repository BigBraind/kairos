defmodule Lifecycle.Timeline.Journey do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:journey_id, :binary_id, autogenerate: false}
  @foreign_key_type :binary_id
  schema "journeys" do
    field :journeyContent, :string
    field :journeyTitle, :string
    field :journeyType, :string
    field :parentJourney, :binary_id
    field :childJourney, :binary_id

    has_many :echoes, Lifecycle.Timeline.Echo
    timestamps()
  end

  @doc false
  def changeset(journey, attrs) do
    journey
    |> cast(attrs, [:journey_id, :journeyType, :journeyTitle, :journeyContent])
    |> validate_required([:journey_id, :journeyType, :journeyTitle, :journeyContent])
  end
end
