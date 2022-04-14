defmodule Lifecycle.UsersFixtures do
  alias Lifecycle.Repo
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Lifecycle.Users` context.
  """

  @doc """
  Generate a realm.
  """
  def realm_fixture(attrs \\ %{}) do
    party= party_fixture()
    {:ok, realm} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "42",
        party_name: party.name
      })
      |> Lifecycle.Users.create_realm()

    realm
  end

  def party_fixture(_attr \\ %{}) do
    user = %Lifecycle.Users.Party{name: "CCP", banner: "ah communism", id: Ecto.UUID.generate()}
    {:ok, party} = Repo.insert(user)
    party
  end
end
