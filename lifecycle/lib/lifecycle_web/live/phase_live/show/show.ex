defmodule LifecycleWeb.PhaseLive.Show do
  @moduledoc false
  use LifecycleWeb, :live_view

  alias Lifecycle.Pubsub
  alias Lifecycle.Timeline
  alias Lifecycle.Timeline.Echo
  alias Lifecycle.Timeline.Phase
  alias Lifecycle.Timeline.Transition
  alias Lifecycle.Timezone

  alias LifecycleWeb.Modal.View.Button.Phases
  alias LifecycleWeb.Modal.View.Echoes.Echoes
  alias LifecycleWeb.Modal.View.Transition.TransitionList

  alias LifecycleWeb.Modal.Function.Button.ApproveHandler
  alias LifecycleWeb.Modal.Function.Component.Flash
  alias LifecycleWeb.Modal.Function.Echoes.EchoHandler
  alias LifecycleWeb.Modal.Function.Pubsub.Pubs
  alias LifecycleWeb.Modal.Function.Pubsub.TransitionPubs
  alias LifecycleWeb.Modal.Function.Transition.TransitionHandler

  @impl true
  def mount(params, _session, socket) do
    phase_id = params["phase_id"]
    echo_changeset = Timeline.Echo.changeset(%Echo{})
    if connected?(socket), do: Pubsub.subscribe("phase:" <> phase_id)

    phase = Timeline.get_phase!(phase_id)
    # * to be used to identify parent phase for crafting journey
    # * true -> parent phase
    check_parent_phase =
      case phase.parent do
        [] -> true
        _ -> false
      end

    {:ok,
     assign(socket,
       echo_changeset: echo_changeset,
       nowstream: [],
       echoes: Timeline.phase_recall(phase_id),
       image_list: [],
       transiting: false,
       transitions: Timeline.get_transition_list(phase_id),
       # * a helper atom to identify whther if this phase is parent phase
       check_parent_phase: check_parent_phase

       # template: Phase.list_traits(id)
     )}
  end

  @impl true
  def handle_params(params, _, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :transition_new, %{"phase_id" => phase_id}) do
    phase = Timeline.get_phase!(phase_id)

    title =
      if socket.assigns.check_parent_phase do
        "New Journey"
      else
        "Proceed to New Phase"
      end

    socket
    |> assign(:phase, phase)
    # a helper atom to identify whther if this phase is parent phase
    |> assign(:check_parent_phase, socket.assigns.check_parent_phase)
    |> assign(:template, Phase.list_traits(phase_id))
    |> assign(:title, title)
    |> assign(:current_user, socket.assigns.current_user)
    |> assign(:changeset, Timeline.change_transition(%Transition{}))
  end

  defp apply_action(socket, :transition_edit, %{
         "phase_id" => phase_id,
         "transition_id" => transition_id
       }) do
    phase = Timeline.get_phase!(phase_id)

    socket
    |> assign(:title, "Edit Transition")
    |> assign(:transition, Timeline.get_transition_by_id(transition_id))
    |> assign(:phase, phase)
    |> assign(:current_user, socket.assigns.current_user)
    |> assign(:changeset, Timeline.change_transition(%Transition{}))
    |> assign(:template, Phase.list_traits(phase_id))
  end

  defp apply_action(socket, :edit, %{"phase_id" => phase_id}) do
    socket
    |> assign(:page_title, "Edit Phase")
    |> assign(:template, Phase.list_traits(phase_id))
    |> assign(:phase, %{Timeline.get_phase!(phase_id) | parent: []})
  end

  # for creating child phase
  defp apply_action(socket, :new_child, params) do
    # IO.inspect(socket.assigns.current_transition)
    IO.inspect(params)
    parent_phase = Timeline.get_phase!(params["phase_id"])

    parent_phase_map = %{parent_phase | parent: parent_phase.id}

    socket
    |> assign(:page_title, "Child Phase")
    |> assign(:phase, parent_phase_map)
    # to get the properties and inherit to child phase
    |> assign(:template, Phase.list_traits(parent_phase.id))
  end

  defp apply_action(socket, :show, %{"phase_id" => phase_id}) do
    socket
    |> assign(:page_title, "Show Phase")
    |> assign(:phase, Timeline.get_phase!(phase_id))
    |> assign(:echoes, Timeline.phase_recall(phase_id))
  end

  @impl true
  def handle_info({Pubsub, [:echo, :created], message}, socket) do
    Pubs.handle_echo_created(socket, message)
  end

  # ! this is now the actual transition instead of the echo transition
  @impl true
  def handle_info({Pubsub, [:transition, :approved], message}, socket) do
    # Pubs.handle_transition_approved(socket, message)
    TransitionPubs.handle_transition_updated(socket, message)
  end

  def handle_info({Pubsub, [:transition, :updated], message}, socket) do
    TransitionPubs.handle_transition_updated(socket, message)
  end

  def handle_info({Pubsub, [:transition, :created], message}, socket) do
    TransitionPubs.handle_transition_created(socket, message)
  end

  def handle_info({Pubsub, [:transition, :deleted], message}, socket) do
    TransitionPubs.handle_transition_deleted(socket, message)
  end

  @impl true
  def handle_info(:clear_flash, socket), do: Flash.handle_flash(socket)

  def handle_event("delete-transition", %{"id" => _transition_id} = params, socket) do
    TransitionHandler.delete_transition(:phase_view, params, socket)
  end

  def handle_event("to_next_phase", params, socket) do
    TransitionHandler.transit_to_next_phase(params, socket)
  end

  def handle_event("transition", _params, socket) do
    TransitionHandler.handle_button("transition", socket)
  end

  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("transit", %{"value" => transition_id}, socket) do
    params = Map.put(%{}, "transition", transition_id)
    TransitionHandler.handle_transition(:assign_transiter, params, socket)
  end

  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :transition, ref)}
  end

  @impl true
  def handle_event("save", %{"echo" => echo_params}, socket) do
    echo_params =
      echo_params
      |> Map.put("phase_id", socket.assigns.phase.id)
      |> Map.put("type", "public")

    EchoHandler.send_echo(echo_params, socket)
  end

  def handle_event("upload", _params, socket) do
    # ! obselete echo transition handler! To be removed
    TransitionHandler.handle_upload("upload", socket)
  end

  def handle_event("approve", params, socket) do
    topic = Pubs.get_topic(socket)
    ApproveHandler.handle_button(params, topic, socket)
  end

  def time_format(time, timezone, timezone_offset),
    do: Timezone.get_time(time, timezone, timezone_offset)

  def error_to_string(:too_large), do: "Too large"
  def error_to_string(:too_many_files), do: "You have selected too many files"
  def error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
end
