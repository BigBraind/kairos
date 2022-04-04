defmodule LifecycleWeb.PhaseLive.Index do
  @moduledoc false
  use LifecycleWeb, :live_view

  alias Lifecycle.Pubsub
  alias Lifecycle.Timeline
  alias Lifecycle.Timeline.Phase
  alias Lifecycle.Timezone

  alias LifecycleWeb.Modal.Function.Component.Flash
  alias LifecycleWeb.Modal.Function.Pubsub.PhasePubs

  @topic "phase_index"

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Pubsub.subscribe(@topic)

    {:ok, assign(socket, phases: list_phases())}
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
    |> assign(:page_title, "New Experiment")
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

  defp get_last_updated_transition_info(phase_id, timezone, timezone_offset) do
    case Timeline.last_transited_by_who_when(phase_id) do
      {:ok, [initiator_name, transition_updated_at]} ->
        transition_datetime =
          Timezone.get_datetime(transition_updated_at, timezone, timezone_offset)

        "Date: #{transition_datetime}\nBy: #{initiator_name}"

      {:error, reason} ->
        reason
    end
  end
end
