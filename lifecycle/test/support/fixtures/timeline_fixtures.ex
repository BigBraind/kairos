defmodule Lifecycle.TimelineFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Lifecycle.Timeline` context.
  """

  @doc """
  Generate a echo.
  """
  def echo_fixture(attrs \\ %{}) do
    {:ok, echo} =
      attrs
      |> Enum.into(%{
        journey: "some journey",
        message: "some message",
        name: "some name",
        type: "some type"
      })
      |> Lifecycle.Timeline.create_echo()

    echo
  end
end
