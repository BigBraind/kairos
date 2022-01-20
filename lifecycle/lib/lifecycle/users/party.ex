defmodule Lifecycle.Users.Party do
  @moduledoc """
  Schema table for party object
  """
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "parties" do

    belongs_to :users, Lifecycle.Users.User

    timestamps()
  end

  # @doc false
  # def changeset(party, attrs) do
  #   party
  #   |> cast(attrs, [:users])
  # end
end
