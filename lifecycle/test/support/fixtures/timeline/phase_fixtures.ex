defmodule Lifecycle.Timeline.PhaseFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Lifecycle.Timeline.Phase` context.
  """

  import Lifecycle.TimelineFixtures

  alias Lifecycle.Timeline.Phase

  @doc """
  Generate a trait.
  """
  def trait_fixture do
    phase = phase_fixture()

    {:ok, trait} =
      %{}
      |> Enum.into(%{
        name: "some name",
        type: "some type",
        value: "some value"
      })
      |> Phase.create_trait(phase)

    trait
  end

  def trait_fixture(phase, attrs \\ %{}) do
    {:ok, trait} =
      attrs
      |> Enum.into(%{
        name: "some name",
        type: "some type",
        value: "some value"
      })
      |> Phase.create_trait(phase)

    trait
  end
end
