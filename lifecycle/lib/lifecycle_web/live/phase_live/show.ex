defmodule LifecycleWeb.PhaseLive.Show do
  use LifecycleWeb, :live_view

  alias Lifecycle.Timeline
  alias Lifecycle.Pubsub
  alias Lifecycle.Timeline.Echo
  alias Lifecycle.Timezone

  @impl true
  def mount(_params, _session, socket) do
    socket = Timezone.getTimezone(socket)
    timezone = socket.assigns.timezone
    timezone_offset = socket.assigns.timezone_offset
    echo_changeset = Timeline.Echo.changeset(%Echo{})
    {:ok, assign(socket, timezone: timezone, echo_changeset: echo_changeset, nowstream: [], timezone_offset: timezone_offset)}
    #abstract and call modular EchoLive Components in future
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    if connected?(socket), do: Pubsub.subscribe("phase:" <> id)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:phase, Timeline.get_phase!(id))
     |> assign(echoes: list_echoes(id))
    }
  end

  def handle_info({Pubsub, [:echo, :created], _message}, socket) do

    {:noreply, assign(socket, :nowstream, [_message | socket.assigns.nowstream])}
  end

  def handle_event("save", %{"echo" => echo_params}, socket) do
    # save_echo(socket, :new, echo_params)
    echo_params = Map.put(echo_params, "phase_id", socket.assigns.phase.id)
    case Timeline.create_echo(echo_params) do
      {:ok, echo} ->
        {Pubsub.notify_subs({:ok, echo}, [:echo, :created], "phase:" <> socket.assigns.phase.id)}
     {:noreply,
         socket
         |> put_flash(:info, "Message Sent")
        }


      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp list_echoes(phase_id) do
    Timeline.phase_recall(phase_id)
  end

  def timeFormat(time, timezone, timezone_offset) do
    time
    |> Timezone.getTime(timezone, timezone_offset)
  end

  defp page_title(:show), do: "Show Phase"
  defp page_title(:edit), do: "Edit Phase"

end
