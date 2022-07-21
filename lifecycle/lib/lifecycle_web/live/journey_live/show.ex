defmodule LifecycleWeb.JourneyLive.Show do
  use LifecycleWeb, :live_view

  alias Lifecycle.Realm

  @impl true
  def mount(%{"id" => id} = _params, _session, socket) do
    case Realm.get_journey!(id) do
      {:ok, journey} -> {:ok, assign(socket, journey: journey, traits_form: [], changeset: Ecto.Changeset.change(journey))}
      _ -> {:ok, assign(socket, :journey, nil)}
    end

  end

  def update_realm_name(resource, %{"journey" => %{"value" => realm_name}}) do
    Realm.update_journey(resource, %{realm_name: realm_name})
  end

  @impl true
  def handle_event("take-down", _params, %{assigns: %{journey: journey}} = socket) do
    case Realm.update_journey(journey, %{active: false}) do
      {:ok, journey} ->
        {:noreply, socket
        |> assign(journey: journey)
        |> put_flash(:info, "journey status updated.")}
      _ ->
        {:noreply, socket
        |> put_flash(:error, "journey status failed to update")}
    end
  end

  @impl true
  def handle_event("trait_management", %{"method" => "delete", "id" => id} = params, %{assigns: %{traits_form: val}} = socket) do
    index = String.to_integer(id)
    {:noreply, assign(socket, [traits_form: List.delete_at(val, index)])}
  end

  @impl true
  def handle_event("trait_management", %{"method" => "add"}, %{assigns: %{traits_form: val}} = socket) do
    {:noreply, assign(socket, [traits_form: val ++ [""]])}
  end

  @impl true
  def handle_event("trait_management", _params, socket) do
    {:noreply, assign(socket, [traits_form: [""]])}
  end

  @impl true
  def handle_event("trait_change", %{"orb" => trait_change} = _params, socket) do
    traits = Map.values(trait_change)
    {:noreply, assign(socket, :traits_form, traits)}
  end


  @impl true
  def handle_event("save_trait", %{"journey" => trait_change} = _params, %{assigns: %{journey: journey}} = socket) do
    traits = Map.values(trait_change)
    case Realm.update_journey(journey, %{traits: journey.traits ++ traits}) do
      {:ok, journey} ->
        {:noreply, socket
        |> assign([journey: journey, traits_form: [], changeset: Ecto.Changeset.change(journey)])
        |> put_flash(:info, "journey traits updated.")}
      _ ->
        {:noreply, socket
        |> put_flash(:error, "journey traits failed to update")}
    end
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
