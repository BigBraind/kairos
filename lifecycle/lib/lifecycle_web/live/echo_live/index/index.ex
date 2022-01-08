defmodule LifecycleWeb.EchoLive.Index do
  @moduledoc false
  use LifecycleWeb, :live_view
  use Timex

  alias Lifecycle.Timezone

  alias Lifecycle.Pubsub

  alias Lifecycle.Timeline
  alias Lifecycle.Timeline.Echo

  # TODO: separate msg by date

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Pubsub.subscribe("1")
    socket = Timezone.get_timezone(socket)
    timezone = socket.assigns.timezone
    timezone_offset = socket.assigns.timezone_offset
    changeset = Timeline.Echo.changeset(%Echo{})
    socket = allow_upload(socket, :transition, accept: ~w(.jpg .jpeg), max_entries: 2)

    {:ok,
     assign(socket,
       echoes: list_echoes(),
       timezone: timezone,
       changeset: changeset,
       nowstream: [],
       timezone_offset: timezone_offset,
       image_list: []
     )}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Msg")
    |> assign(:echo, %Echo{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Message")
    |> assign(:echo, nil)
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
          #  |> Pubsub.notify_subs([:echo, :created], "1")
          # pub sub to be added
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  @impl true
  def handle_info({Pubsub, [:echo, :created], message}, socket) do
    {:noreply, assign(socket, :nowstream, [message | socket.assigns.nowstream])}
  end

  defp list_echoes do
    Timeline.recall()
  end

  def time_format(time, timezone, timezone_offset) do
    time
    |> Timezone.get_time(timezone, timezone_offset)
  end


  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end


  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :transition, ref)}
  end

  def handle_event("transit", _params, socket) do
    uploaded_files =
      consume_uploaded_entries(socket, :transition, fn %{path: path}, _entry ->
        dest = Path.join([:code.priv_dir(:lifecycle), "static", "uploads", Path.basename(path)])
        File.cp!(path, dest)
        Routes.static_path(socket, "/#{Path.basename(dest)}")
      end)

    {:noreply, update(socket, :image_list, &(&1 ++ uploaded_files))}
  end


  def error_to_string(:too_large), do: "Too large"
  def error_to_string(:too_many_files), do: "You have selected too many files"
  def error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
end
