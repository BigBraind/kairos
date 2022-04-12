defmodule Lifecycle.RealmFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Lifecycle.Realm` context.
  """

  @doc """
  Generate a journey.
  """
  def journey_fixture(attrs \\ %{}) do
    {:ok, journey} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Lifecycle.Realm.create_journey()

    journey
  end
end
