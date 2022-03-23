defmodule Lifecycle.TimelineFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Lifecycle.Timeline` context.
  """

  alias Lifecycle.Timeline
  alias Lifecycle.Repo

  alias Ecto.UUID

  @doc """
  Generate a echo.
  """
  def echo_fixture(attrs \\ %{}) do
    phase = phase_fixture()
    user = user_fixture()

    {:ok, echo} =
      attrs
      |> Enum.into(%{
        phase_id: phase.id,
        user_name: user.name,
        message: "some message",
        # type: "type"
      })
      |> Timeline.create_echo()

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
        id: UUID.generate()
      })
      |> Timeline.create_phase()

   %{phase | parent: [], child: [], traits: []} # add child and parent
  end

  def user_fixture(_attr \\ %{}) do
    {:ok, user} =
      %Lifecycle.Users.User{name: "Nietzsche", id: Ecto.UUID.generate()}
      |> Repo.insert()

    user
  end
end
