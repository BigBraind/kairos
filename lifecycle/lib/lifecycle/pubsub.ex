defmodule Lifecycle.Pubsub do
  @moduledoc """
    This module includes the pub sub implementation
  """
  def subscribe(topic) do
    Phoenix.PubSub.subscribe(Lifecycle.PubSub, topic)
  end

  def notify_subs({:ok, result}, event, topic) do
    Phoenix.PubSub.broadcast(Lifecycle.PubSub, topic, {__MODULE__, event, result})
    {:ok, result}
  end

  def notify_subs({:error, reason}, _event) do
    {:error, reason}
  end
end
