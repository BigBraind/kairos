defmodule Lifecycle.Timeline.Phase.Trait do
  @moduledoc """
    Schema table for Phase Objects
  """

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "traits" do
    field(:name, :string)
    # Enum
    field(:type, Ecto.Enum, values: [:num, :txt, :img, :bool])
    field(:value, :string)
    field(:unit, :string)
    field(:path, :string, virtual: true) # for image handling in transition_answers
    field(:tracker, :string, virtual: true)
    field(:deletion, :boolean, virtual: true)
    belongs_to(:phase, Lifecycle.Timeline.Phase, foreign_key: :phase_id)

    timestamps()
  end

  @doc false
  def changeset(trait, attrs) do
    trait
    |> Map.put(:tracker, trait.tracker || attrs["tracker"])
    |> cast(attrs, [:name, :value, :type, :phase_id, :unit, :deletion])
    |> validate_required([:name, :type])
    |> unique_constraint(:name, name: :repeat_traits)
    |> delete()
  end

  defp delete(%{data: %{id: nil}} = changeset), do: changeset

  defp delete(changeset) do
    if get_change(changeset, :deletion) do
      %{changeset | action: :deletion}
    else
      changeset
    end
  end
end
