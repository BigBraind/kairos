defmodule LifecycleWeb.JourneyLive.Show do
  use LifecycleWeb, :live_view

  alias Lifecycle.Realm

  @impl true
  def mount(params, _session, socket) do
    IO.inspect params
    {:ok,
    assign(socket, :journeys, list_journeys())
  }
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:journey, Realm.get_journey!(id))}
  end

  @impl true
  def handle_params(%{"realm_name" => realm_name, "journey_pointer" => pointer}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:journey, Realm.get_journey_by_realm_attrs!(realm_name, pointer))}
     #|> assign(:journeys, [-1,0,1] |> Enum.map(fn inc -> Realm.get_journey_by_realm_attrs!(realm_name, String.to_integer(pointer) + inc) end))
  end

  defp list_journeys do
    Realm.list_journeys()
  end

  defp page_title(:show), do: "Show Journey"
  defp page_title(:edit), do: "Edit Journey"
  defp page_title(:new), do: "Next Journey"
end
