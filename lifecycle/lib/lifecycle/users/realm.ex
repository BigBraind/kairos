defmodule Lifecycle.Users.Realm do
  use Ecto.Schema
  import Ecto.Changeset

  alias Lifecycle.Users.Party

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "realms" do
    field :description, :string
    field :name, :string
    belongs_to :party, Party, foreign_key: :party_id
    timestamps()
  end

  @doc false
  def changeset(realm, attrs) do
    realm
    |> cast(attrs, [:name,:party_id, :description])
    |> validate_required([:name, :description])
    |> unique_constraint(:homologous_realms, name: :unique_realms)
  end
end
