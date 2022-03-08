defmodule LifecycleWeb.TransitionLive.FormComponent do
  @moduledoc false
  use LifecycleWeb, :live_component

  alias Lifecycle.Pubsub
  alias Lifecycle.Timeline
  alias Lifecycle.Timeline.Transition

  alias LifecycleWeb.Modal.Function.Button.TransitionHandler

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, Timeline.change_transition(%Transition{}))}
  end

  # def handle_event("validate", %{"transition" => transition}, socket) do
  #   save_transition(socket, socket.assigns.action, transition)
  # end

  @impl true
  def handle_event("save", %{"transition" => transition}, socket) do
    save_transition(socket, socket.assigns.action, transition)
  end

  # correspond to the save event
  defp save_transition(socket, :transition_new, params) do
    params =
      %{}
      |> Map.put(:answers, params)
      |> Map.put(:initiator_id, socket.assigns.current_user.id)
      |> Map.put(:phase_id, socket.assigns.phase.id)

    case Timeline.create_transition(params) do
      {:ok, transition} ->
        {Pubsub.notify_subs(
           {:ok, transition},
           [:transition, :created],
           "phase:" <> socket.assigns.phase.id
         )}

        {:noreply,
         socket
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp save_transition(socket, :transition_edit, params) do
    params =
      %{}
      |> Map.put("answers", params)
      |> Map.put("transition", socket.assigns.transition.id)

    TransitionHandler.handle_transition(:edit_transition, params, socket)
  end
end
