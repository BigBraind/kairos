defmodule LifecycleWeb.TransitionLive.FormComponent do
  @moduledoc false
  use LifecycleWeb, :live_component

  alias Lifecycle.Timeline
  alias Lifecycle.Timeline.Transition

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, Timeline.change_transition(%Transition{}))}
  end

  def handle_event("validate", %{"transition" => transition}, socket) do
    handle_transition(socket, socket.assigns.action, transition)
  end

  def handle_event("save", %{"transition" => transition}, socket) do
    handle_transition(socket, socket.assigns.action, transition)
  end

  # correspond to the save event
  defp handle_transition(socket, :transition_new, params) do
    params =
      %{}
      |> Map.put(:answers, params)
      |> Map.put(:initiator_id, socket.assigns.current_user.id)
      |> Map.put(:phase_id, socket.assigns.phase.id)

    case Timeline.create_transition(params) do
      {:ok, _transition} ->
        IO.puts("transition create event")

        {:noreply,
         socket
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp handle_transition(socket, :transition_edit, params) do
    params = Map.put(%{}, "answers", params)

    case Timeline.update_transition(socket.assigns.transition, params) do
      {:ok, _transition} ->
        IO.puts("transition update event")

        {:noreply,
         socket
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply,
         socket
         |> assign(changeset: changeset)}
    end
  end
end
