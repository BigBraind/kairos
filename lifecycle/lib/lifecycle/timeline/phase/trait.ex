defmodule Lifecycle.Timeline.Phase.Trait do
  use Ecto.Schema
  import Ecto.Changeset


  @foreign_key_type :binary_id
  schema "traits" do
    field :name, :string
    field :type, :string
    field :value, :string
    field :unit, :string
    field :tracker, :string, virtual: true
    field :deletion, :boolean, virtual: true
    belongs_to :phase , Lifecycle.Timeline.Phase, foreign_key: :phase_id


    timestamps()
  end

  @doc false
  def changeset(trait, attrs) do
    trait
    |> Map.put(:tracker, (trait.tracker || attrs["tracker"]))
    |> cast(attrs, [:name, :value, :type, :phase_id, :unit, :deletion])
    |> validate_required([:name, :value, :type])
    |> unique_constraint(:name, name: :variants_name_value_product_id_index)
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
