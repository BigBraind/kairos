defmodule LifecycleWeb.EchoLive.Index do
  @moduledoc false
  use LifecycleWeb, :live_view
  use Timex

  alias Lifecycle.Timezone

  alias Lifecycle.Pubsub

  alias Lifecycle.Timeline
  alias Lifecycle.Timeline.Echo

  alias LifecycleWeb.Modal.Button.Transition
  alias LifecycleWeb.Modal.Echoes.Echoes
  alias LifecycleWeb.Modal.Button.Approve
  alias LifecycleWeb.Modal.Pubsub.Pubs

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Pubsub.subscribe("1")
    socket = Timezone.get_timezone(socket)
    timezone = socket.assigns.timezone
    timezone_offset = socket.assigns.timezone_offset
    changeset = Timeline.Echo.changeset(%Echo{})

    socket =
      allow_upload(socket, :transition,
        accept: ~w(.png .jpg .jpeg .mp3 .m4a .aac .oga),
        max_entries: 1
      )

    {:ok,
     assign(socket,
       echoes: list_echoes(),
       timezone: timezone,
       changeset: changeset,
       nowstream: [],
       timezone_offset: timezone_offset,
       image_list: [],
       transiting: false
     )}
  end

  @impl true
  def handle_event("save", %{"echo" => echo_params}, socket) do
    case Timeline.create_echo(echo_params) do
      {:ok, echo} ->
        {Pubsub.notify_subs({:ok, echo}, [:echo, :created], "1")}

        {
          :noreply,
          socket
          |> put_flash(:info, "Message Sent")
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def handle_event("transition", _params, socket) do
    Transition.handle_button("transition", socket)
  end

  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :transition, ref)}
  end

  def handle_event("upload", _params, socket) do
    Transition.handle_upload("upload", socket)
  end

  def handle_event("approve", %{"value" => id}, socket) do
    Approve.handle_button(%{"value" => id}, "1", socket)
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
