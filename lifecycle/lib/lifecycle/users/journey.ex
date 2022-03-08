defmodule Lifecycle.Users.Journey do
  @moduledoc """
    Schema table for Phase Objects
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "journeys" do
    # field :id, :binary_id, primary_key: true
    has_one :party, Lifecycle.Users.Party, foreign_key: :party_id

    timestamps()
  end

  @doc false
  def changeset(journey, attrs) do
    journey
    |> cast(attrs, [])
  end
end
