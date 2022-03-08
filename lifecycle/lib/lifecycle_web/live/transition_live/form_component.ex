defmodule LifecycleWeb.TransitionLive.FormComponent do
  @moduledoc false
  use LifecycleWeb, :live_component

  alias Lifecycle.Pubsub
  alias Lifecycle.Timeline
  alias Lifecycle.Timeline.Transition

  alias LifecycleWeb.Modal.Function.Button.TransitionHandler
  alias LifecycleWeb.Modal.Function.Transition.ImageHandler

  @impl true
  def update(assigns, socket) do
    socket =
      allow_upload(socket, :transition,
        accept: ~w(.png .jpg .jpeg .mp3 .m4a .aac .oga),
        max_entries: 3
      )

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, Timeline.change_transition(%Transition{}))}
  end

  @impl true
  def handle_event("validate", %{"transition" => _transition}, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("save", %{"transition" => transition}, socket) do
    save_transition(socket, socket.assigns.action, transition)
  end

  # saving transition object
  defp save_transition(socket, :transition_new, params) do
    image_list = ImageHandler.handle_image(socket)
    params = Map.put(params, "image_list", image_list)
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

  # TODO: new helper function to identify text_input, number_input or checkbox based on the type of trait
  # to be used in form_compnent.html.heex

  def error_to_string(:too_large), do: "Too large"
  def error_to_string(:too_many_files), do: "You have selected too many files"
  def error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
end
