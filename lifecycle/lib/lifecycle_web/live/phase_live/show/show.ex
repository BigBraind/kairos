defmodule LifecycleWeb.PhaseLive.Show do
  @moduledoc false
  use LifecycleWeb, :live_view

  alias Lifecycle.Pubsub
  alias Lifecycle.Timeline
  alias Lifecycle.Timeline.Echo
  alias Lifecycle.Timezone

  alias LifecycleWeb.Modal.View.Button.Phases
  alias LifecycleWeb.Modal.View.Button.Transition
  alias LifecycleWeb.Modal.View.Echoes.Echoes

  alias LifecycleWeb.Modal.Function.Button.ApproveHandler
  alias LifecycleWeb.Modal.Function.Button.TransitionHandler
  alias LifecycleWeb.Modal.Function.Component.Flash
  alias LifecycleWeb.Modal.Function.Echoes.EchoHandler
  alias LifecycleWeb.Modal.Function.Pubsub.Pubs

  @impl true
  def mount(params, _session, socket) do
    id = params["id"]
    socket = Timezone.get_timezone(socket)
    echo_changeset = Timeline.Echo.changeset(%Echo{})
    if connected?(socket), do: Pubsub.subscribe("phase:" <> id)

    socket =
      allow_upload(socket, :transition,
        accept: ~w(.png .jpg .jpeg .mp3 .m4a .aac .oga),
        max_entries: 1
      )

    {:ok,
     assign(socket,
       echo_changeset: echo_changeset,
       nowstream: [],
       echoes: list_echoes(id),
       image_list: [],
       transiting: false
     )}
  end

  @impl true
  def handle_params(params, _, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Phase")
    |> assign(:phase, %{Timeline.get_phase!(id) | parent: []})
  end

  defp apply_action(socket, :new, params) do
    parent_phase = Timeline.get_phase!(params["id"])
    parent_phase = %{parent_phase | parent: parent_phase.id}

    socket
    |> assign(:page_title, "Child Phase")
    |> assign(:title, "Hello")
    |> assign(:phase, parent_phase)
  end

  defp apply_action(socket, :show, %{"id" => id}) do
    socket
    |> assign(:page_title, "Show Phase")
    |> assign(:phase, Timeline.get_phase!(id))
    |> assign(:echoes, list_echoes(id))
  end

  @impl true
  def handle_info({Pubsub, [:echo, :created], message}, socket) do
    Pubs.handle_echo_created(socket, message)
  end

  @impl true
  def handle_info({Pubsub, [:transition, :approved], message}, socket) do
    Pubs.handle_transition_approved(socket, message)
  end

  @impl true
  def handle_info(:clear_flash, socket), do: Flash.handle_flash(socket)

  def handle_event("transition", _params, socket) do
    TransitionHandler.handle_button("transition", socket)
  end

  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :transition, ref)}
  end

  @impl true
  def handle_event("save", %{"echo" => echo_params}, socket) do
    echo_params = Map.put(echo_params, "phase_id", socket.assigns.phase.id)
    EchoHandler.send_echo(echo_params, socket)
  end

  def handle_event("upload", _params, socket) do
    TransitionHandler.handle_upload("upload", socket)
  end

  def handle_event("approve", params, socket) do
    topic = Pubs.get_topic(socket)
    ApproveHandler.handle_button(params, topic, socket)
  end

  defp list_echoes(phase_id), do: Timeline.phase_recall(phase_id)

  def time_format(time, timezone, timezone_offset), do: Timezone.get_time(time, timezone, timezone_offset)

  def error_to_string(:too_large), do: "Too large"
  def error_to_string(:too_many_files), do: "You have selected too many files"
  def error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
end
