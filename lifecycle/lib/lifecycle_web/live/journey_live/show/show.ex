defmodule LifecycleWeb.JourneyLive.Show do
  use LifecycleWeb, :live_view

  alias Lifecycle.Timeline

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:journey, Timeline.get_journey!(id))}
  end

  defp page_title(:show), do: "Show Journey"
  defp page_title(:edit), do: "Edit Journey"
end
