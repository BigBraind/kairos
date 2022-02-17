defmodule LifecycleWeb.EchoLive.Index do
  @moduledoc false
  use LifecycleWeb, :live_view
  use Timex

  alias Lifecycle.Pubsub
  alias Lifecycle.Timeline
  alias Lifecycle.Timeline.Echo
  alias Lifecycle.Timezone

  alias LifecycleWeb.Modal.View.Button.Transition
  alias LifecycleWeb.Modal.View.Echoes.Echoes

  alias LifecycleWeb.Modal.Function.Button.ApproveHandler
  alias LifecycleWeb.Modal.Function.Button.TransitionHandler
  alias LifecycleWeb.Modal.Function.Echoes.EchoHandler
  alias LifecycleWeb.Modal.Function.Pubsub.Pubs

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Pubsub.subscribe("1")
    socket = Timezone.get_timezone(socket)
    changeset = Timeline.Echo.changeset(%Echo{})

    socket =
      allow_upload(socket, :transition,
        accept: ~w(.png .jpg .jpeg .mp3 .m4a .aac .oga),
        max_entries: 1
      )

    {:ok,
     assign(socket,
       echoes: list_echoes(),
       changeset: changeset,
       nowstream: [],
       image_list: [],
       transiting: false
     )}
  end

  @impl true
  def handle_event("save", %{"echo" => echo_params}, socket) do
    EchoHandler.send_echo(echo_params, socket)
  end

  def handle_event("transition", _params, socket) do
    TransitionHandler.handle_button("transition", socket)
  end

  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :transition, ref)}
  end

  def handle_event("upload", _params, socket) do
    TransitionHandler.handle_upload("upload", socket)
  end

  def handle_event("approve", %{"value" => id}, socket) do
    topic = Pubs.get_topic(socket)
    ApproveHandler.handle_button(%{"value" => id}, topic, socket)
  end

  @impl true
  def handle_info({Pubsub, [:echo, :created], message}, socket) do
    Pubs.handle_echo_created(socket, message)
  end

  @impl true
  def handle_info({Pubsub, [:transition, :approved], message}, socket) do
    Pubs.handle_transition_approved(socket, message)
  end

  defp list_echoes do
    Timeline.recall()
  end

  def error_to_string(:too_large), do: "Too large"
  def error_to_string(:too_many_files), do: "You have selected too many files"
  def error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
end
