defmodule LifecycleWeb.JourneyLive.Show do
  use LifecycleWeb, :live_view

  alias Lifecycle.Realm

  @impl true
  def mount(%{"id" => id} = _params, _session, socket) do
    case Realm.get_journey!(id) do
      {:ok, journey} -> {:ok, assign(socket, journey: journey, changeset: Ecto.Changeset.change(journey))}
      _ -> {:ok, assign(socket, :journey, nil)}
    end

  end

  def update_name(resource, %{"journey" => %{"value" => name}}) do
    Realm.update_journey(resource, %{name: name})
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    journey = Realm.get_journey!(id)
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:journey, journey)
     |> assign(:changeset, Realm.change_journey(journey))}
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
    Realm.list_journeys() # change to +- 2
  end

  defp page_title(:show), do: "Show Journey"
  defp page_title(:edit), do: "Edit Journey"
  defp page_title(:new), do: "Next Journey"
end
