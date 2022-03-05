defmodule Lifecycle.Timeline.Phase.Trait do
  use Ecto.Schema
  import Ecto.Changeset


  @foreign_key_type :binary_id
  schema "traits" do
    field :name, :string
    field :type, :string
    field :value, :string
    belongs_to :phase , Lifecycle.Timeline.Phase, foreign_key: :phase_id


    timestamps()
  end

  @doc false
  def changeset(trait, attrs) do
    trait
    |> cast(attrs, [:name, :value, :type, :phase_id])
    |> validate_required([:name, :value, :type])
    |> unique_constraint(:name, name: :variants_name_value_product_id_index)
  end
end
