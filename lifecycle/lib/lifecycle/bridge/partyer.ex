defmodule Lifecycle.Bridge.Partyer do
  @moduledoc """
    Schema for Partyer object
    Link between Party (Group) and Users
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Lifecycle.Users.Party
  alias Lifecycle.Users.User

  @primary_key false
  @foreign_key_type :binary_id
  schema "party_user_link" do
    belongs_to :party, Party
    belongs_to :user, User
  end

  @doc false
  def changeset(link, attrs \\ %{}) do
    link
    |> cast(attrs, [:party_id, :user_id])
    |> validate_required([:party_id, :user_id])
  end
end
