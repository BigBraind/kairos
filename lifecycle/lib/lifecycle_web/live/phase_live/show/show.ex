defmodule LifecycleWeb.PhaseLive.Show do
  @moduledoc false
  use LifecycleWeb, :live_view

  use Phoenix.LiveView
  on_mount {LifecycleWeb.Auth.Protocol, :auth}

  alias Lifecycle.Timeline
  alias Lifecycle.Pubsub
  alias Lifecycle.Timeline.{Echo, Phase}
  alias Lifecycle.Timezone

  @impl true
  def mount(params, _session, socket) do
    id = params["id"]
    socket = Timezone.get_timezone(socket)
    timezone = socket.assigns.timezone
    timezone_offset = socket.assigns.timezone_offset
    echo_changeset = Timeline.Echo.changeset(%Echo{})
    if connected?(socket), do: Pubsub.subscribe("phase:" <> id)

    {:ok,
     assign(socket,
       timezone: timezone,
       echo_changeset: echo_changeset,
       nowstream: [],
       timezone_offset: timezone_offset,
       echoes: list_echoes(id)
     )}
  end

  @impl true
  def handle_params(%{"id" => id} = params, _, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Phase")
    |> assign(:phase, Timeline.get_phase!(id))
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
  def handle_info({Pubsub, [:echo, :created], _message}, socket) do
    {:noreply, assign(socket, :nowstream, [_message | socket.assigns.nowstream])}
  end

  @impl true
  def handle_event("save", %{"echo" => echo_params}, socket) do
    echo_params = Map.put(echo_params, "phase_id", socket.assigns.phase.id)
    echo_params = Map.put(echo_params, "name", socket.assigns.current_user.name)

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
end
