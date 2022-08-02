defmodule LifecycleWeb.JourneyLive.Show do
  use LifecycleWeb, :live_view

  alias Lifecycle.Realm
  alias Lifecycle.Realm.Journey
  alias Lifecycle.Timeline.Phase
  alias LifecycleWeb.Modal.View.Transition.TransitionList

  @impl true
  def mount(params, _session, socket) do
    {:ok,
    socket |> assign(:journeys, list_journeys()) |> assign(:search_result, "")
  }
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    journey = Realm.get_journey!(id)
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:journey, journey)
     |> assign(:changeset, Realm.change_journey(journey))
     |> assign(journey_list: [])
     |> assign(steps_in_journey: [])
    }
  end

  @impl true
  def handle_params(%{"realm_name" => realm_name, "journey_pointer" => pointer}, _, socket) do
    pointer = String.to_integer(pointer)
    journey_list = [-1, 0, 1]
      |> Enum.map(fn inc -> Realm.get_journey_by_realm_attrs(realm_name, pointer + inc)
    end)


    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:journey, Realm.get_journey_by_realm_attrs(realm_name, pointer))
     |> assign(journey_list: journey_list)
     |> assign(steps_in_journey: [])
     |> apply_action(socket.assigns.live_action)
    }
  end

  defp apply_action(socket, :step_child) do
    #parent_phase = Timeline.get_phase!() get phase from last transition in phase

    parent_phase_map =  %{} #%{parent_phase | parent: parent_phase.id}

    socket
    |> assign(:phase, parent_phase_map)
    # to get the properties and inherit to child phase
    #|> assign(:template, Phase.list_traits(parent_phase.id))
  end

  defp apply_action(socket, :step) do
    socket
    |> assign(:phase, %{%Phase{traits: []} | parent: []})
  end

  defp apply_action(socket, :show) do
    socket
  end

  defp apply_action(socket, :new) do
    socket
  end

  def handle_event("search", %{"search_journey" => %{"pointer" => pointer_str}}, socket)  do
    # TODO: to be replaced by actual search function
    realm_name = socket.assigns.journey.realm_name
    try do
      Realm.get_journey_by_realm_attrs(realm_name, String.to_integer(pointer_str))
      |> case do
           %Journey{:realm_name => realm_name, :pointer => pointer} ->

             {:noreply, socket |> push_redirect(to: Routes.journey_show_path(socket, :show, realm_name, pointer))}

           nil ->
             search_result = "Journey doesn't exist yet, create it below."

             {:noreply,
               assign(socket,
                 search_result: search_result)}
         end
    rescue

    ArgumentError ->
        search_result = "Invalid Search Attributes"

             {:noreply,
               assign(socket,
                 search_result: search_result)}
    end
  end


  defp list_journeys do
    Realm.list_journeys() # change to +- 2
  end

  defp page_title(:show), do: "Show Journey"
  defp page_title(:edit), do: "Edit Journey"
  defp page_title(:new), do: "Next Journey"
  defp page_title(:step), do: "Next Step in Journey"
end
