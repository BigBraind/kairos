defmodule Lifecycle.Bridge.Phasor do

  use Ecto.Schema
  import Ecto.Changeset

  schema "phase_phase_link" do
    field :parent_id, :binary_id
    field :child_id, :binary_id
    timestamps()
  end

  @doc false
  def changeset(link, attrs) do
    link
    |> cast(attrs, [:parent_id, :child_id])
    |> unique_constraint([:parent_id, :child_id], name: :parent_to_child)
    |> unique_constraint([:child_id, :parent_id], name: :child_to_parent)
  end
end
