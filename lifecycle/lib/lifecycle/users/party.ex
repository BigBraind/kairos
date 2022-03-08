defmodule Lifecycle.Users.Party do
  @moduledoc """
  Schema table for party object
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Lifecycle.Bridge.Membership
  alias Lifecycle.Users.User

  @primary_key {:id, :binary_id, autogenerate: true}
  # @foreign_key_type :binary_id
  schema "parties" do
    field :name, :string

    field :banner, :string
    many_to_many :user, User, join_through: Membership
    has_many :journey, Lifecycle.Users.Journey, foreign_key: :journey_id
    timestamps()
  end

  @doc false
  def changeset(party, attrs \\ %{}) do
    party
    |> cast(attrs, [:name, :banner])
    |> update_change(:name, &String.downcase/1)
    |> validate_required([:banner, :name])
    |> unique_constraint(:name, name: :parties_name_index)
  end
end
