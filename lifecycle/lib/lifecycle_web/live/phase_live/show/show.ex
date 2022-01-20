defmodule LifecycleWeb.PhaseLive.Show do
  @moduledoc false
  use LifecycleWeb, :live_view

  alias Lifecycle.Timeline
  alias Lifecycle.Pubsub
  alias Lifecycle.Timeline.{Echo, Phase}
  alias Lifecycle.Timezone

  alias LifecycleWeb.Modal.Button.Transition
  alias LifecycleWeb.Modal.Echoes.Echoes
  alias LifecycleWeb.Modal.Echoes.EchoList
  alias LifecycleWeb.Modal.Button.Approve

  @impl true
  def mount(params, _session, socket) do
    id = params["id"]
    socket = Timezone.get_timezone(socket)
    timezone = socket.assigns.timezone
    timezone_offset = socket.assigns.timezone_offset
    echo_changeset = Timeline.Echo.changeset(%Echo{})
    if connected?(socket), do: Pubsub.subscribe("phase:" <> id)
    socket = allow_upload(socket, :transition, accept: ~w(.png .jpg .jpeg .mp3), max_entries: 1)

    {:ok,
     assign(socket,
       timezone: timezone,
       echo_changeset: echo_changeset,
       nowstream: [],
       timezone_offset: timezone_offset,
       echoes: list_echoes(id),
       image_list: [],
       transiting: false
     )}
  end

  @impl true
  @spec handle_params(map, any, %{
          :assigns => atom | %{:live_action => :edit | :new | :show, optional(any) => any},
          optional(any) => any
        }) :: {:noreply, map}
  def handle_params(%{"id" => id} = params, _, socket) do
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
    IO.inspect parent_phase

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
  def handle_info({Pubsub, [:echo, :created], _message}, socket) do
    {:noreply, assign(socket, :nowstream, [_message | socket.assigns.nowstream])}
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

  @impl true
  def handle_event("save", %{"echo" => echo_params}, socket) do
    echo_params = Map.put(echo_params, "phase_id", socket.assigns.phase.id)

    case Timeline.create_echo(echo_params) do
      {:ok, echo} ->
        {Pubsub.notify_subs({:ok, echo}, [:echo, :created], "phase:" <> socket.assigns.phase.id)}

        {:noreply,
         socket
         |> put_flash(:info, "Message Sent")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  @doc """
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
      "transited" => false,
      "phase_id" => socket.assigns.phase.id
    }

    case Timeline.create_echo(echo_params) do
      {:ok, echo} ->
        {Pubsub.notify_subs({:ok, echo}, [:echo, :created], "phase:" <> socket.assigns.phase.id)}

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

  def handle_event("approve", %{"value" => id} = params, socket) do
    topic = "phase:" <> socket.assigns.phase.id
    Approve.handle_button(params, topic, socket)
  end

  defp list_echoes(phase_id) do
    Timeline.phase_recall(phase_id)
  end

  def time_format(time, timezone, timezone_offset) do
    time
    |> Timezone.get_time(timezone, timezone_offset)
  end

  defp page_title(:show), do: "Show Phase"
  defp page_title(:edit), do: "Edit Phase"
  defp page_title(:new), do: "Child Phase"

  def error_to_string(:too_large), do: "Too large"
  def error_to_string(:too_many_files), do: "You have selected too many files"
  def error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
end
