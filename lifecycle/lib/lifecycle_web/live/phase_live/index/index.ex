defmodule LifecycleWeb.PhaseLive.Index do
  use LifecycleWeb, :live_view
  on_mount LifecycleWeb.Auth.Protocol

  alias Lifecycle.Timeline
  alias Lifecycle.Timeline.Phase

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :phases, list_phases())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Phase")
    |> assign(:phase, Timeline.get_phase!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Phase")
    |> assign(:title, "Hello")
    |> assign(:phase, %Phase{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Phases")
    |> assign(:phase, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    phase = Timeline.get_phase!(id)
    {:ok, _} = Timeline.delete_phase(phase)

    {:noreply, assign(socket, :phases, list_phases())}
  end

  defp list_phases do
    Timeline.list_phases()
  end
end
