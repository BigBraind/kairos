defmodule Lifecycle.Bridge.Journeyer do
  @moduledoc """
    Schema for Journeyer object
    Link between Journey and Party Objects
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Lifecycle.Users.Journey
  alias Lifecycle.Users.Party

  @primary_key false
  @foreign_key_type :binary_id
  schema "journey_party_link" do
    belongs_to :journey_id, Journey
    belongs_to :party_id, Party

    timestamps()
  end

  @doc false
  def changeset(link, attrs \\ %{}) do
    link
    |> cast(attrs, [:journey_id, :party_id])
    |> validate_required([:journey_id, :party_id])

    # |> unique_constraint([:parent_id, :child_id], name: :parent_to_child)
    # |> unique_constraint([:child_id, :parent_id], name: :child_to_parent)
  end
end
