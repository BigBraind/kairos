defmodule LifecycleWeb.PhaseLive.Show do
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
     |> assign(:phase, Timeline.get_phase!(id))}
  end

  defp page_title(:show), do: "Show Phase"
  defp page_title(:edit), do: "Edit Phase"
end
