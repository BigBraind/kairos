defmodule Lifecycle.PubsubFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Lifecycle.Pubsub` context.
  """

  @doc """
  Generate a pubsub topic.
  """
  def pubsub_fixture(attrs \\ %{}) do
    pubsub =
      attrs
      |> Enum.into(%{
          topic: "some topics",
          message: "Some unimportant msg",
          event: [:pubsub, :tested],
                   })

    pubsub
  end
end
