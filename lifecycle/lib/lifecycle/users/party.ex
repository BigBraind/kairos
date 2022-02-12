defmodule Lifecycle.Users.Party do
  @moduledoc """
  Schema table for party object
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Lifecycle.Users.User
  alias Lifecycle.Bridge.Membership

  @primary_key {:id, :binary_id, autogenerate: true}
  # @foreign_key_type :binary_id
  schema "parties" do
    field :name, :string
    field :banner, :string
    many_to_many :user, User, join_through: Membership


    timestamps()
  end

  @doc false
  def changeset(party, attrs \\ %{}) do
    party
    |> cast(attrs, [:name, :banner])
    |> validate_required([:banner, :name])
    |> unique_constraint(:name)
  end
end
