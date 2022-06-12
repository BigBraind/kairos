defmodule LifecycleWeb.JourneyLive.Index do
  use LifecycleWeb, :live_view

  alias Lifecycle.Realm
  alias Lifecycle.Realm.Journey

  @vertical_list_1 [
    %{transition_id: 1.1, name: "transition_1"},
    %{transition_id: 2.1, name: "transition_2"},
    %{transition_id: 3.1, name: "transition_3"}
  ]

  @vertical_list_2 [
    %{transition_id: 1.2, name: "transition_1"},
    %{transition_id: 2.2, name: "transition_2"},
    %{transition_id: 3.2, name: "transition_3"}
  ]

  @vertical_list_3 [
    %{transition_id: 1.3, name: "transition_1"},
    %{transition_id: 2.3, name: "transition_2"},
    %{transition_id: 3.3, name: "transition_3"}
  ]

  @impl true
  def mount(_params, _session, socket) do
    sub_left = %{journey_id: 1, name: "journey_1"}
    sub = %{journey_id: 2, name: "journey_2"}
    sub_right = %{journey_id: 3, name: "journey_3"}

    {:ok,
     assign(socket,
       journeys: list_journeys(),
       sub_left: sub_left,
       sub: sub,
       sub_right: sub_right,
       vertical_list_1: @vertical_list_1,
       vertical_list_2: @vertical_list_2,
       vertical_list_3: @vertical_list_3
     )}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Journey")
    |> assign(:journey, Realm.get_journey!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Journey")
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

  def handle_event("left", %{"journeyid" => journey_id}, socket) do
    case journey_id do
      "2" -> {:noreply, assign(socket, transition: @vertical_list_1 )}
    end
  end

  def handle_event("right", %{"journeyid" => journey_id}, socket) do
    case journey_id do
      "2" -> {:noreply, assign(socket, transition: @vertical_list_3 )}
    end
  end

  defp list_journeys do
    Realm.list_journeys()
  end
end
