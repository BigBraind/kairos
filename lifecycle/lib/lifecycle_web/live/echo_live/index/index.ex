defmodule LifecycleWeb.EchoLive.Index do
  use LifecycleWeb, :live_view
  use Timex

  alias Lifecycle.Timezone

  alias Lifecycle.Pubsub

  alias Lifecycle.Timeline
  alias Lifecycle.Timeline.Echo

  @topic inspect(__MODULE__)

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Pubsub.subscribe("1") #topic TODO change the topic
    socket = Timezone.getTimezone(socket)
    timezone = socket.assigns.timezone
    timezone_offset = socket.assigns.timezone_offset
    changeset = Timeline.Echo.changeset(%Echo{})
    {:ok, assign(socket, echoes: list_echoes(), timezone: timezone, changeset: changeset, nowstream: [], timezone_offset: timezone_offset)}
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

  def handle_event("save", %{"echo" => echo_params}, socket) do
    # save_echo(socket, :new, echo_params)
    case Timeline.create_echo(echo_params) do
      {:ok, echo} ->
        {Pubsub.notify_subs({:ok, echo}, [:echo, :created], "1")}
     {:noreply,
         socket
         |> put_flash(:info, "Message Sent")
        #  |> Pubsub.notify_subs([:echo, :created], "1")
         # pub sub to be added
        }


      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def handle_info({Pubsub, [:echo, :created], _message}, socket) do

    {:noreply, assign(socket, :nowstream, [_message | socket.assigns.nowstream])}
  end

  defp list_echoes do
    Timeline.recall()
  end

  def timeFormat(time, timezone, timezone_offset) do
    time
    |> Timezone.getTime(timezone, timezone_offset)
  end
end
