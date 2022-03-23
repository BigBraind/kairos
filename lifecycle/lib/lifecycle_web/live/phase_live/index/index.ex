defmodule LifecycleWeb.PhaseLive.Index do
  @moduledoc false
  use LifecycleWeb, :live_view

  alias Lifecycle.Pubsub
  alias Lifecycle.Timeline
  alias Lifecycle.Timeline.Phase
  alias Lifecycle.Timeline.Transition
  alias Lifecycle.Timezone

  alias LifecycleWeb.Modal.Function.Component.Flash
  alias LifecycleWeb.Modal.Function.Pubsub.PhasePubs

  @topic "phase_index"

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Pubsub.subscribe(@topic)

    socket =
      socket
      |> Timezone.get_current_end_date(socket.assigns.timezone)

    start_date = socket.assigns.current_date
    end_date = socket.assigns.end_date

    socket =
      socket
      |> assign(
        :transitions_by_date,
        Timeline.get_transition_by_date(
          start_date,
          end_date
        )
      )
      |> assign(phases: list_phases())

    # import IEx
    # IEx.pry()

    # {:ok, assign(socket, :phases, list_phases())}
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  # ! when i create new trait from here, somehow it was automatically being recorded into the database
  # ! why is this happening?
  # ! also cnnot delete traits on :edit
  defp apply_action(socket, :edit, %{"phase_id" => phase_id}) do
    socket
    |> assign(:page_title, "Edit Phase")
    |> assign(:template, Phase.list_traits(phase_id))
    |> assign(:phase, %{Timeline.get_phase!(phase_id) | parent: []})
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Phase")
    # |> assign(:template, nil) #so that i can pass through the index.html
    |> assign(:phase, %{%Phase{traits: []} | parent: []})
  end

  defp apply_action(socket, :index, _params) do
    socket =
      socket
      |> Timezone.get_current_end_date(socket.assigns.timezone)

    socket
    |> assign(:page_title, "Listing Phases")
    |> assign(:phase, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    phase = Timeline.get_phase!(id)
    {:ok, deleted_phase} = Timeline.delete_phase(phase)

    {Pubsub.notify_subs({:ok, deleted_phase}, [:phase, :deleted], @topic)}

    {:noreply,
     socket
     |> assign(:phases, list_phases())
     |> Flash.insert_flash(:info, "Phase deleted", self())}
  end

  @impl true
  def handle_info(:clear_flash, socket), do: Flash.handle_flash(socket)

  @impl true
  def handle_info({Pubsub, [:phase, :created], message}, socket) do
    PhasePubs.handle_phase_created(socket, message)
  end

  @impl true
  def handle_info({Pubsub, [:phase, :edited], message}, socket) do
    PhasePubs.handle_phase_edited(socket, message)
  end

  @impl true
  def handle_info({Pubsub, [:phase, :deleted], message}, socket) do
    PhasePubs.handle_phase_deleted(socket, message)
  end

  defp list_phases do
    Timeline.list_phases()
  end

  defp check_if_transition_exist(socket, phase_id, transitions) do
    # case(
    #   Timeline.get_transition_by_date(
    #     start_date,
    #     end_date
    #   )
    # ) do
    #   [] ->
    #     "false"
    # assign(socket, :transited, "false")

    # transitions ->
    #   Enum.map(transitions, fn
    #     %Transition{phase_id: id} ->
    #       if id == phase_id do
    #         "true"
    #         # assign(socket, :transited, "true")
    #       else
    #         "false"
    #         # assign(socket, :transited, "false")
    #       end
    #   end)
    # end
    Enum.map(transitions, fn
      %Transition{phase_id: id} ->
        if id == phase_id do
          "true"
          # assign(socket, :transited, "true")
        else
          ""
          # assign(socket, :transited, "false")
        end
    end)
  end
end
