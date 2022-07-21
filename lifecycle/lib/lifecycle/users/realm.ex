defmodule Lifecycle.Users.Realm do
  use Ecto.Schema
  import Ecto.Changeset

  alias Lifecycle.Users.Party
  alias Lifecycle.Realm.Journey

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "realms" do
    field :description, :string
    field :name, :string
    belongs_to :party, Party, foreign_key: :party_name, type: :string
    has_many :journeys, Journey, foreign_key: :realm_name
    timestamps()
  end

  @doc false
  def changeset(realm, attrs) do
    realm
    |> cast(attrs, [:name, :party_name, :description])
    |> validate_required([:name])
    #|> unique_constraint(:homologous_realms, name: :unique_realms)
    |> unique_constraint(:homologous_realms, name: :realms_name_index)
  end
end
