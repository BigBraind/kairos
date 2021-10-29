defmodule LifecycleWeb.EchoLive.Index do
  use LifecycleWeb, :live_view
  use Timex

  alias Lifecycle.Timezone

  alias Lifecycle.Timeline
  alias Lifecycle.Timeline.Echo

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Timeline.subscribe() #topic TODO
    socket = Timezone.getTimezone(socket)
    timezone = socket.assigns.timezone
    changeset = Timeline.Echo.changeset(%Echo{})
    {:ok, assign(socket, echoes: list_echoes(), timezone: timezone, changeset: changeset, nowstream: [])}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Echo")
    |> assign(:echo, Timeline.get_echo!(id))
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
  def handle_event("delete", %{"id" => id}, socket) do
    echo = Timeline.get_echo!(id)
    {:ok, _} = Timeline.delete_echo(echo)

    {:noreply, assign(socket, :echoes, list_echoes())}
  end

  def handle_event("enter", %{"key" => "Enter"}, socket) do
    IO.inspect("Test from handle_event")
    IO.inspect(socket.assigns.msg)
    IO.inspect(socket.assigns.name)
    {:noreply, socket}
    # save_echo(socket, socket.assigns.action, echo_params)
  end

  def handle_event("save", %{"echo" => echo_params}, socket) do
    # save_echo(socket, :new, echo_params)
    case Timeline.create_echo(echo_params) do
      {:ok, _echo} ->
        {:noreply,
         socket
         |> put_flash(:info, "Echo created successfully")
         # pub sub to be added
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  @impl true
  def handle_event("validate", %{"echo" => echo_params}, socket) do
    IO.inspect socket.assigns

    changeset =
      socket.assigns.echo
      |> Timeline.change_echo(echo_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_info({Lifecycle.Timeline, [:echo, :created], _message}, socket) do
    IO.inspect("caught u")
    {:noreply, assign(socket, :nowstream, [_message | socket.assigns.nowstream])}
  end

  def handle_info(_unknown, socket) do
    IO.inspect "Hello"
    IO.inspect _unknown
    {:noreply, socket}
  end

  defp list_echoes do
    Timeline.list_echoes()
  end

  def timeFormat(time, timezone) do
    time
    |> DateTime.from_naive!("Etc/UTC")
    |> Timex.shift(hours: +8)
    |> Timex.format("{YYYY}-{0M}-{D}")
    |> elem(1)
  end
end
