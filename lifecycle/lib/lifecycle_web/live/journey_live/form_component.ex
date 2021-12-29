defmodule LifecycleWeb.JourneyLive.FormComponent do
  use LifecycleWeb, :live_component

  alias Lifecycle.Timeline

  @impl true
  def update(%{journey: journey} = assigns, socket) do
    changeset = Timeline.change_journey(journey)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"journey" => journeys_params}, socket) do
    changeset =
      socket.assigns.journey
      |> Timeline.change_journey(journeys_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"journey" => journeys_params}, socket) do
    save_journeys(socket, socket.assigns.action, journeys_params)
  end

  defp save_journeys(socket, :edit, journeys_params) do
    case Timeline.update_journey(socket.assigns.journey, journeys_params) do
      {:ok, _journeys} ->
        {:noreply,
         socket
         |> put_flash(:info, "Journeys updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_journeys(socket, :new, journeys_params) do
    case Timeline.create_journey(journeys_params) do
      {:ok, _journeys} ->
        {:noreply,
         socket
         |> put_flash(:info, "Journeys created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
