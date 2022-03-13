defmodule Lifecycle.Orgs.Realm do
  @moduledoc """
  The Realm context. aka Repo
  """
  use Ecto.Schema
  
  import Ecto.Changeset
  import Ecto.Query, warn: false
  alias Lifecycle.Users.Party

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "realms" do
    field :name, :string
    field :description, :string
    has_many :parties, Party, foreign_key: :journey_id
    timestamps()
  end
end
