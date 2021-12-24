defmodule Lifecycle.Timeline.Journey do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "journeys" do
    field :journeyContent, :string
    field :journeyTitle, :string
    field :journeyType, :string
    field :parentJourney, :binary_id
    field :childJourney, :binary_id

    timestamps()
  end

  @doc false
  def changeset(journey, attrs) do
    journey
    |> cast(attrs, [:journeyType, :journeyTitle, :journeyContent])
    |> validate_required([:journeyType, :journeyTitle, :journeyContent])
  end
end
