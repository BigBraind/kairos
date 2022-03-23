
defmodule Lifecycle.Bridge.Membership do
  @moduledoc """
    Schema for Partyer-Membership
    Link between Party (Group) & Users through Membership => Roles in Realm
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Lifecycle.Users.Party
  alias Lifecycle.Users.User

  @primary_key false
  @foreign_key_type :binary_id

  schema "party_membership" do
    field :role, Ecto.Enum, values: [:lead, :whip, :pleb] # ! What the heck is this whip??? :/
    belongs_to :party, Party
    belongs_to :user, User
    timestamps()
  end

  @doc false
  def changeset(link, attrs \\ %{}) do
    link

    |> cast(attrs, [:party_id, :user_id, :role])
    |> validate_required([:party_id, :user_id, :role])
    |> unique_constraint(:membership_overload, name: :my_membership)
    |> unique_constraint(:name, name: :party_membership_party_id_user_id_index)
  end
end
