defmodule Lifecycle.Users.Party do
  @moduledoc """
  Schema table for party object
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Lifecycle.Users.User
  alias Lifecycle.Bridge.Partyer

  @primary_key {:id, :binary_id, autogenerate: true}
  # @foreign_key_type :binary_id
  schema "parties" do
    field :name, :string
    belongs_to :users, User
    many_to_many :user, User, join_through: Partyer


    timestamps()
  end

  @doc false
  def changeset(party, attrs \\ %{}) do
    party
    |> cast(attrs, [:users])
  end
end
