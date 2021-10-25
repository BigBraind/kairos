defmodule LifecycleWeb.EchoLive.Index do
  use LifecycleWeb, :live_view
  use Timex

  alias Lifecycle.Timezone

  alias Lifecycle.Timeline
  alias Lifecycle.Timeline.Echo

  @impl true
  def mount(_params, _session, socket) do
    socket = Timezone.getTimezone(socket)
    timezone = socket.assigns.timezone
    # IO.inspect socket.assigns.timezone
    {:ok, assign(socket, echoes: list_echoes(), timezone: timezone)}
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

  defp list_echoes do
    Timeline.list_echoes()
  end

  def timeFormat(time, timezoned) do
    IO.inspect(timezoned)
    time
    |> DateTime.from_naive!("Etc/UTC")
    |> Timex.shift(hours: +10)
    |> Timex.format("{YYYY}-{0M}-{D}")
    |> elem(1)
    # |> DateTime.shift_zone("America/Los_Angeles")
    #|> DateTime.shift_zone()
    #|> DateTime.to_unix()
  end
end
