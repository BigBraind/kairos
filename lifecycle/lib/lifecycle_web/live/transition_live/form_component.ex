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
  def handle_event("save", %{"transition" => transition} = _, socket) do
    transition = transition
    |> Enum.map(fn {k,v} -> {assigntypes(k), mergetypes(k,v, transition)} end) # type-specific  numeric/unit merger
    |> Enum.group_by(fn {k, _v} -> k end) # parsing together types
    |> Enum.map(fn {k,v} -> {k, mergetypes(k,v)} end) # bundle together data related to types
    |> Enum.into(%{}) #keywordlist to map
    |> Map.put("image_list", ImageHandler.handle_image(socket))
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

  def mergetypes(key, value, maps) do
    [type | name] = String.split(key, "#", parts: 2)
    name = unless List.first(name) == nil , do: List.first(name)
    case type do
      "comment" ->
        %{"value" => value}
      "bool" ->
        %{name => %{"value" => value}}
      "numeric" ->
        %{name => %{"value" => value, "unit" => maps["unit#" <> name]}}
      "text" ->
        %{name => %{"value" => value}}
      _jk ->
        %{}
    end
  end

  def assigntypes(key) do
    case String.to_atom(List.first(String.split(key, "#"))) do
      :unit ->
        :unit
      :numeric ->
        :numeric
      :text ->
        :text
      :bool ->
        :bool
      :comment ->
        :comment
      _unrecognised_type ->
        :unknown
    end
  end

  def mergetypes(key, value) do
    ## data merger
    Enum.reduce(Keyword.get_values(value, key), fn x, y ->
      Map.merge(x, y, fn _k, v1, v2 -> v2 ++ v1 end) end)
  end


  def error_to_string(:too_large), do: "Too large" #just like your mum HA got em -not glen
  def error_to_string(:too_many_files), do: "You have selected too many files"
  def error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
end
