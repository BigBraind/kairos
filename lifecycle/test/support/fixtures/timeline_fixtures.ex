defmodule Lifecycle.TimelineFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Lifecycle.Timeline` context.
  """

  @doc """
  Generate a echo.
  """
  def echo_fixture(attrs \\ %{}) do
    journey = journey_fixture()
    {:ok, echo} =
      attrs
      |> Enum.into(%{
          journey_id: journey.journey_id,
          message: "some message",
          name: "some name",
          #type: "type"
                   })
                   |> Lifecycle.Timeline.create_echo()
      IO.inspect echo
      echo
  end

  @doc """
  Generate a journey.
  """
  def journey_fixture(attrs \\ %{}) do
    {:ok, journey} =
      attrs
      |> Enum.into(%{
          journey_type: "testType",
          journey_title: "testTitle",
          journey_content: "testContent",
          journey_id: Ecto.UUID.generate()
                   })
                   |> Lifecycle.Timeline.create_journey()

      journey
  end

  @doc """
  Generate a phase.
  """
  def phase_fixture(attrs \\ %{}) do
    {:ok, phase} =
      attrs
      |> Enum.into(%{
        content: "some content",
        title: "some title",
        type: "some type"
      })
      |> Lifecycle.Timeline.create_phase()

    phase
  end
end
