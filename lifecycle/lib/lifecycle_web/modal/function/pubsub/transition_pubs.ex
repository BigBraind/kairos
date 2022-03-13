defmodule LifecycleWeb.Modal.Function.Pubsub.TransitionPubs do
  @moduledoc """
  Handler pubsubs for transition object being craeted, edited and deleted
  """
  use Phoenix.Component

  alias Lifecycle.Timeline
  alias Lifecycle.Timeline.Transition

  def handle_transition_created(socket, message) do
    new_transition = Timeline.get_transition_by_id(message.id)

    {:noreply,
     socket
     |> assign(:transitions, [new_transition | socket.assigns.transitions])}
  end

  def handle_transition_deleted(socket, message) do
    {:noreply, assign(socket, transitions: Timeline.get_transition_list(message.phase_id))}
  end

  @doc """
  Handle pubsub for 1. approve event 2. edit transition event
  """
  def handle_transition_updated(socket, message) do
    params = %{
      transition_id: message.id,
      transitions: socket.assigns.transitions,
      transiter_id: socket.assigns.current_user.id,
      socket: socket
    }

    {:noreply, assign(socket, transitions: replace_transition(params))}
  end

  @doc """
  Helper function to identify the transition object being updated and return the updated transition object
  """
  def replace_transition(%{
        transition_id: transition_id,
        transitions: transitions
      }) do
    updated_transition = Timeline.get_transition_by_id(transition_id)

    Enum.map(transitions, fn
      %Transition{id: id} = old_transition ->
        if id == transition_id do
          updated_transition
        else
          old_transition
        end
    end)
  end
end
