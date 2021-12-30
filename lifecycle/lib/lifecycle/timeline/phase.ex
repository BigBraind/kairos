defmodule Lifecycle.Timeline.Phase do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "phases" do
    field :content, :string
    field :title, :string
    field :type, :string
    field :parent, :binary_id
    field :child, :binary_id
    has_many :echoes, Lifecycle.Timeline.Echo, foreign_key: :phase_id

    timestamps()
  end

  @doc false
  def changeset(phase, attrs) do
    phase
    |> cast(attrs, [:content, :title, :type, :parent])
    |> validate_required([:content, :title, :type])
  end
end
