defmodule Lifecycle.Bridge.Realmer do
  @moduledoc """
    Schema for Phasor object
    Link between phases
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Lifecycle.Realm.Journey
  alias Lifecycle.Users.Realm

  @primary_key false
  @foreign_key_type :binary_id
  schema "realm_journey_link" do
    belongs_to :realm, Realm
    field :pointer, :integer
    belongs_to :journey, Journey
    timestamps()
  end

  @doc false
  def changeset(link, attrs \\ %{}) do
    link
    |> cast(attrs, [:realm_id, :pointer, :journey_id])
    |> validate_required([:realm_id, :pointer, :journey_id])
    |> unique_constraint(:name, name: :realm_journey_index)
  end
end
