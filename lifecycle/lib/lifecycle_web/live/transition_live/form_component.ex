defmodule LifecycleWeb.TransitionLive.FormComponent do
  @moduledoc false
  use LifecycleWeb, :live_component

  alias Lifecycle.Pubsub
  alias Lifecycle.Timeline
  alias Lifecycle.Timeline.Transition

  alias LifecycleWeb.Modal.Function.Transition.ImageHandler
  alias LifecycleWeb.Modal.Function.Transition.TransitionHandler

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
  def handle_event("save", %{"transition" => transition} = params, socket) do
    # IO.inspect transition
    # # import IEx; IEx.pry()
    # new_transition = Map.new(transition, fn {k, v} -> {transition_map_parser(k,v)} end)
    # import IEx; IEx.pry()
    image_list = ImageHandler.handle_image(socket)
    transition = Map.put(transition, "image_list", image_list)

    save_transition(socket, socket.assigns.action, transition)
  end

  # saving transition object
  defp save_transition(socket, :transition_new, answer_map) do
    answer_map =
      %{}
      |> Map.put(:answers, answer_map)
      |> Map.put(:initiator_id, socket.assigns.current_user.id)
      |> Map.put(:phase_id, socket.assigns.phase.id)

    case Timeline.create_transition(answer_map) do
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

  def transition_map_parser(key, value) do
    [type | name] = String.split(key, "#", parts: 2) # what's the point???
    name = unless List.first(name) == nil , do: List.first(name)
    case type do
      "comment" ->
        %{:comment => value}
      "bool" ->
        %{:bool => %{name => %{"value" => value}}}
      "numeric" ->
        %{:numeric => %{name => %{"value" => value}}}
      "text" ->
        %{:text => %{name => %{"value" => value}}}
      "unit" ->
        %{:numeric => %{name => %{"unit" => value}}}
      _jk ->
        IO.inspect 1
        %{}
    end
  end

  def error_to_string(:too_large), do: "Too large"
  def error_to_string(:too_many_files), do: "You have selected too many files"
  def error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
end
