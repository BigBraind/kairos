defmodule Lifecycle.Bridge.Phasor do
  use Ecto.Schema
  import Ecto.Changeset
  alias Lifecycle.Timeline.Phase

  @primary_key false
  @foreign_key_type :binary_id
  schema "phase_phase_link" do
    belongs_to :parent, Phase
    belongs_to :child, Phase
    timestamps()
  end

  @doc false
  def changeset(link, attrs \\ %{}) do
    link
    |> cast(attrs, [:parent_id, :child_id])
    |> validate_required([:parent_id, :child_id])

    # |> unique_constraint([:parent_id, :child_id], name: :parent_to_child)
    # |> unique_constraint([:child_id, :parent_id], name: :child_to_parent)
  end
end
