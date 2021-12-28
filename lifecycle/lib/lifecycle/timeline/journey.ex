defmodule Lifecycle.Timeline.Journey do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:journey_id, :binary_id, autogenerate: false}
  # @foreign_key
  @foreign_key_type :binary_id
  schema "journeys" do
    field :journey_content, :string
    field :journey_title, :string
    field :journey_type, :string
    field :parent_journey, :binary_id
    field :child_journey, :binary_id

    has_many :echoes, Lifecycle.Timeline.Echo, foreign_key: :journey_id
    timestamps()
  end

  @doc false
  def changeset(journey, attrs \\ %{}) do
    journey
    |> cast(attrs, [:journey_id, :journey_type, :journey_title, :journey_content])
    |> validate_required([:journey_id, :journey_type, :journey_title, :journey_content])
  end
end
