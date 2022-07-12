defmodule LifecycleWeb.JourneyLive.Index do
  use LifecycleWeb, :live_view

  alias Lifecycle.Realm
  alias Lifecycle.Realm.Journey

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :journeys, list_journeys())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    #import IEx; IEx.pry()
    socket
    |> assign(:page_title, "Edit Journey")
    |> assign(:journey, Realm.get_journey!(id))
  end

  defp apply_action(socket, :start, _params) do
    socket
    |> assign(:page_title, "Start Journey in New Realm")
    |> assign(:journey, %Journey{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Journeys")
    |> assign(:journey, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    journey = Realm.get_journey!(id)
    {:ok, _} = Realm.delete_journey(journey)

    {:noreply, assign(socket, :journeys, list_journeys())}
  end

  defp list_journeys do
    Realm.list_journeys()
  end
end
