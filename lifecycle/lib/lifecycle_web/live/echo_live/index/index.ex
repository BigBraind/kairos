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
  alias LifecycleWeb.Modal.Echoes.EchoList
  alias LifecycleWeb.Modal.Button.Approve

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Pubsub.subscribe("1")
    socket = Timezone.get_timezone(socket)
    timezone = socket.assigns.timezone
    timezone_offset = socket.assigns.timezone_offset
    changeset = Timeline.Echo.changeset(%Echo{})
    socket = allow_upload(socket, :transition, accept: ~w(.png .jpg .jpeg), max_entries: 1)

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

  @impl true
  def handle_info({Pubsub, [:echo, :created], message}, socket) do
    {:noreply, assign(socket, :nowstream, [message | socket.assigns.nowstream])}
  end

  @impl true
  def handle_info({Pubsub, [:transition, :approved], message}, socket) do
    params = %{
      id: message.id,
      transiter: socket.assigns.current_user.name,
      echo_stream: :placeholder,
      socket: socket
    }

    {:noreply,
     socket
     |> assign(:nowstream, replace_echoes(%{params | echo_stream: :nowstream}))
     |> assign(:echoes, replace_echoes(%{params | echo_stream: :echoes}))}
  end

  defp replace_echoes(%{
         id: id,
         transiter: transiter,
         # list of [:nowstream, :echoes]
         echo_stream: echo_stream,
         socket: socket
       }) do
    # pass back :ok, or :cont
    Enum.map(socket.assigns[echo_stream], fn
      %Echo{id: id} = echo -> %Echo{echo | transiter: transiter, transited: true}
      echo -> echo
    end)
  end

  defp list_echoes do
    Timeline.recall()
  end

  @doc """
    button event by transition button
  """
  def handle_event("transition", _params, socket) do
    Transition.handle_button("transition", socket)
  end

  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :transition, ref)}
  end

  @doc """
  new docs
  Construct the file path of the image uploaded, and save it to local file system
  Create transition echo object
  """
  def handle_event("transit", _params, socket) do
    # function to get the file path and save it to local file system
    uploaded_files =
      consume_uploaded_entries(socket, :transition, fn %{path: path}, entry ->
        ext = entry.client_name
        dest_path = path <> ext
        # changes destination path name with extension for rendering
        dest =
          Path.join([:code.priv_dir(:lifecycle), "static", "uploads", Path.basename(dest_path)])

        File.cp!(path, dest)
        Routes.static_path(socket, "/uploads/#{Path.basename(dest)}")
      end)

    # convert list to string
    image_list = Enum.join(uploaded_files, "##")

    # construct echo_params for creating transition echo objects
    echo_params = %{
      "message" => image_list,
      "type" => "transition",
      "name" => socket.assigns.current_user.name,
      "transited" => false
    }

    case Timeline.create_echo(echo_params) do
      {:ok, echo} ->
        {Pubsub.notify_subs({:ok, echo}, [:echo, :created], "1")}

        {
          :noreply,
          socket
          |> assign(:transiting, false)
          |> put_flash(:info, "Transition Object Sent")
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def handle_event("approve", %{"value" => id}, socket) do
    topic = "1"
    Approve.handle_button(%{"value" => id}, topic, socket)
    # Approve.handle_button(%{"value" => id}, "1", socket)
  end

  def error_to_string(:too_large), do: "Too large"
  def error_to_string(:too_many_files), do: "You have selected too many files"
  def error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
end
