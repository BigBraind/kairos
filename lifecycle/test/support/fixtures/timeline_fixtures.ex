defmodule Lifecycle.TimelineFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Lifecycle.Timeline` context.
  """

  @doc """
  Generate a echo.
  """
  def echo_fixture(attrs \\ %{}) do
    phase = phase_fixture()

    {:ok, echo} =
      attrs
      |> Enum.into(%{
        phase_id: phase.id,
        message: "some message",
        name: "some name"
        # type: "type"
      })
      |> Lifecycle.Timeline.create_echo()

    echo
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
        type: "some type",
        id: Ecto.UUID.generate()
      })
      |> Lifecycle.Timeline.create_phase()
      
   %{phase | parent: [], child: []} # add child and parent
  end
end
