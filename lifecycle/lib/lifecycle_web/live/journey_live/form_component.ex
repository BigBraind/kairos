defmodule LifecycleWeb.JourneyLive.FormComponent do
  use LifecycleWeb, :live_component

  alias Lifecycle.Realm

  @impl true
  def update(%{journey: journey} = assigns, socket) do
    changeset = Realm.change_journey(journey)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"journey" => journey_params}, socket) do
    changeset =
      socket.assigns.journey
      |> Realm.change_journey(journey_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"journey" => journey_params}, socket) do
    save_journey(socket, socket.assigns.action, journey_params)
  end

  defp save_journey(socket, :edit, journey_params) do
    case Realm.update_journey(socket.assigns.journey, journey_params) do
      {:ok, _journey} ->
        {:noreply,
         socket
         |> put_flash(:info, "Journey updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_journey(socket, :new, journey_params) do
    case Realm.create_journey(journey_params) do
      {:ok, _journey} ->
        {:noreply,
         socket
         |> put_flash(:info, "Journey created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
