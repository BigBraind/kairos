defmodule Lifecycle.UsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Lifecycle.Users` context.
  """

  @doc """
  Generate a realm.
  """
  def realm_fixture(attrs \\ %{}) do
    {:ok, realm} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name"
      })
      |> Lifecycle.Users.create_realm()

    realm
  end
end
