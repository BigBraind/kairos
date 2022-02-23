defmodule Lifecycle.Users.User do
  @moduledoc """
  Schema table for user object
  """
  use Ecto.Schema
  alias Lifecycle.Bridge.Membership
  alias Lifecycle.Users.Party
  alias Lifecycle.Timeline.Transition

  use Pow.Ecto.Schema,
    user_id_field: :name,
    password_hash_methods:
      {&Pow.Ecto.Schema.Password.pbkdf2_hash/1, &Pow.Ecto.Schema.Password.pbkdf2_verify/2},
    password_min_length: 8,
    password_max_length: 4096

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "users" do
    # field :custom_field, :string

    pow_user_fields()
    has_many :parties, Membership, foreign_key: :user_id
    many_to_many :party, Party, join_through: Membership
    has_many :transitions, Transition, foreign_key: :transition_id
    has_many :transits, Transition, foreign_key: :transit_id

    timestamps()

    # has_many :party, Lifecycle.Users.Party
  end

  def changeset(user_or_changeset, attrs) do
    pow_changeset(user_or_changeset, attrs)
  end
end
