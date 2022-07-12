defmodule Lifecycle.Realm.Journey do
  use Ecto.Schema
  import Ecto.Changeset

  alias Lifecycle.Timeline.Transition
  alias Lifecycle.Users.Party
  alias Lifecycle.Users.Realm


  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "journeys" do
    field :name, :string
    field :pointer, :integer
    belongs_to :party, Party, foreign_key: :party_id
    has_many :transitions, Transition, foreign_key: :journey_id
    belongs_to :realm, Realm, foreign_key: :realm_name, references: :name, type: :string
    timestamps()
  end

  @doc false
  def changeset(journey, attrs) do
    journey
    |> cast(attrs, [:name, :pointer])
    |> cast_assoc(:realm, on_replace: :update)
    |> validate_required([:name])
  end

  def non_realm_changeset(journey, attrs) do
    journey
    |> cast(attrs, [:name, :pointer])
    |> validate_required([:name])
  end

end
