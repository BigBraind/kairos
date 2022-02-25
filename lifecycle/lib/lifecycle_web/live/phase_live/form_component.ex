defmodule LifecycleWeb.PhaseLive.FormComponent do
  @moduledoc false
  use LifecycleWeb, :live_component

  alias Lifecycle.Timeline

  alias LifecycleWeb.Modal.Function.Component.Flash

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
         |> push_redirect(to: socket.assigns.return_to)
         |> Flash.insert_flash(:info, "Phase updated successfully", self())}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_phase(socket, :new, phase_params) do
    template =
      %{}
      |> check_true_value("water", phase_params["water"])
      |> check_true_value("grain", phase_params["grain"])
      |> check_true_value("coconut", phase_params["coconut"])

    # creating a new map to pass into create_phase
    phase_params =
      %{}
      |> Map.put("template", template)
      |> Map.put("content", phase_params["content"])
      |> Map.put("title", phase_params["title"])
      |> Map.put("type", phase_params["type"])
      |> Map.put("parent", phase_params["parent"])


    case Timeline.create_phase(phase_params) do
      {:ok, phase} ->
        {:noreply,
         socket
         # "/phases/" <> phase.id
         |> push_redirect(to: Routes.phase_show_path(socket, :show, phase.id))
         |> Flash.insert_flash(:info, "Phase created successfully", self())}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def handle_flash(socket), do: {:noreply, clear_flash(socket)}

  defp check_true_value(map, key, value) do
    case value do
      "true" ->
        Map.merge(map, %{String.to_atom(key) => ""})

      _ ->
        map
    end
  end
end
