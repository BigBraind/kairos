defmodule LifecycleWeb.PhaseLive.FormComponent do
  @moduledoc false
  use LifecycleWeb, :live_component

  alias Ecto.Changeset
  alias Lifecycle.Pubsub
  alias Lifecycle.Timeline
  alias Lifecycle.Timeline.Phase
  alias Lifecycle.Timeline.Phase.Trait

  alias LifecycleWeb.Modal.Function.Component.Flash

  @topic "phase_index"

  @impl true
  def update(%{phase: phase} = assigns, socket) do
    changeset =
      Timeline.change_phase(phase)
      |> Changeset.put_assoc(:traits, phase.traits)

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

  def handle_event("add-trait", _, socket) do
    existing_traits =
      Map.get(socket.assigns.changeset.changes, :traits, socket.assigns.phase.traits)

    traits =
      existing_traits
      |> Enum.concat([
        Phase.change_trait(%Trait{tracker: gen_tracker()})
      ])

    changeset = Changeset.put_assoc(socket.assigns.changeset, :traits, traits)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("remove_trait", %{"remove" => remove_id}, socket) do
    # remove_id => tracker_id to be removed
    traits =
      socket.assigns.changeset.changes.traits
      |> Enum.reject(fn %{data: trait} ->
        trait.tracker == remove_id
      end)

    changeset =
      socket.assigns.changeset
      |> Changeset.put_assoc(:traits, traits)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event(
        "delete_trait",
        %{"phase-id" => phase_id, "trait-id" => trait_id},
        socket
      ) do
    {:ok, trait_deleted} =
      phase_id
      |> Phase.get_trait!(trait_id)
      |> Phase.delete_trait()

    updated_traits =
      socket.assigns.phase.traits
      |> Enum.reject(fn %{id: id} ->
        id == trait_deleted.id
      end)

    changeset =
      socket.assigns.changeset
      |> Changeset.put_assoc(:traits, updated_traits)

    {:noreply, assign(socket, changeset: changeset)}
  end

  defp save_phase(socket, :edit, phase_params) do
    case Timeline.update_phase(socket.assigns.phase, phase_params) do
      {:ok, phase} ->
        {Pubsub.notify_subs({:ok, phase}, [:phase, :edited], @topic)}

        {:noreply,
         socket
         |> push_redirect(to: socket.assigns.return_to)
         |> Flash.insert_flash(:info, "Phase updated successfully", self())}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  """
    TODO:
      Future improvement:
        1. Create a list of properties(water, grain, coconut, peanuts, tea etc)
        2. Loop through the list to get the properties
  """

  defp save_phase(socket, :new, phase_params) do
    phase_params =
      %{}
      |> Map.put("content", phase_params["content"])
      |> Map.put("title", phase_params["title"])
      |> Map.put("type", phase_params["type"])
      |> Map.put("parent", phase_params["parent"])

    create_phase(:new, phase_params, socket)
  end

  defp save_phase(socket, :new_child, phase_params) do
    trait_list =
      for trait <- Map.values(phase_params["traits"]) do
        trait
      end

    trait_list = List.flatten(trait_list)

    phase_params =
      %{}
      |> Map.put("existing_traits", trait_list)
      # |> Map.put("template", template)
      |> Map.put("content", phase_params["content"])
      |> Map.put("title", phase_params["title"])
      |> Map.put("type", phase_params["type"])
      |> Map.put("parent", phase_params["parent"])

    create_phase(:new_child, phase_params, socket)
  end

  defp create_phase(action, phase_params, socket) do
    check_trait = Map.has_key?(socket.assigns.changeset.changes, :traits)
    check_existing_trait = phase_params["existing_traits"] != %{}

    case Timeline.create_phase(phase_params) do
      {:ok, phase} ->
        # TODO: TYPE AND UNIT NOT IMPLEMENTED YET
        # to avoid raising KeyError
        if check_trait do
          _trait_map =
            socket.assigns.changeset.changes.traits
            |> Enum.map(fn t -> t.changes end)
            |> Enum.map(fn t -> Phase.create_trait(t, phase) end)
        end

        if check_existing_trait do
          for trait <- phase_params["existing_traits"] do
            trait
            |> Phase.create_trait(phase)
          end
        end

        case action do
          :new ->
            {Pubsub.notify_subs({:ok, phase}, [:phase, :created], "phase_index")}

          :new_child ->
            {Pubsub.notify_subs(
               {:ok, phase},
               [:phase, :created],
               "phase:" <> socket.assigns.phase.id
             )}
        end

        {:noreply,
         socket
         |> push_redirect(to: Routes.phase_show_path(socket, :show, phase.id))
         |> Flash.insert_flash(:info, "Phase created successfully", self())}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def handle_flash(socket), do: {:noreply, clear_flash(socket)}

  defp gen_tracker, do: :crypto.strong_rand_bytes(5) |> Base.url_encode64() |> binary_part(0, 5)
end
