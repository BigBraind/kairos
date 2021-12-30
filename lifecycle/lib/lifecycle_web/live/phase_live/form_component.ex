defmodule LifecycleWeb.PhaseLive.FormComponent do
  use LifecycleWeb, :live_component

  alias Lifecycle.Timeline

  @impl true
  def update(%{phase: phase} = assigns, socket) do
    changeset = Timeline.change_phase(phase)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"phase" => phase_params}, socket) do
    changeset =
      socket.assigns.phase
      |> Timeline.change_phase(phase_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"phase" => phase_params}, socket) do
    save_phase(socket, socket.assigns.action, phase_params)
  end

  defp save_phase(socket, :edit, phase_params) do
    case Timeline.update_phase(socket.assigns.phase, phase_params) do
      {:ok, _phase} ->
        {:noreply,
         socket
         |> put_flash(:info, "Phase updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_phase(socket, :new, phase_params) do
    case Timeline.create_phase(phase_params) do
      {:ok, phase} ->
        {:noreply,
         socket
         |> put_flash(:info, "Phase created successfully")
         |> push_redirect(to: Routes.phase_show_path(socket, :show, phase.id)) #"/phases/" <> phase.id
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
