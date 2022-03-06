defmodule LifecycleWeb.PhaseLive.Index do
  @moduledoc false
  use LifecycleWeb, :live_view

  alias Lifecycle.Pubsub
  alias Lifecycle.Timeline
  alias Lifecycle.Timeline.Phase

  alias LifecycleWeb.Modal.Function.Component.Flash
  alias LifecycleWeb.Modal.Function.Pubsub.PhasePubs

  @topic "phase_index"

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Pubsub.subscribe(@topic)
    {:ok, assign(socket, :phases, list_phases())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Phase")
    |> assign(:template, Timeline.get_phase!(id).template)
    |> assign(:phase, %{Timeline.get_phase!(id) | parent: []})
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Phase")
    #|> assign(:template, nil) #so that i can pass through the index.html
    |> assign(:phase, %{%Phase{traits: []} | parent: []})
  end

  defp apply_action(socket, :index, _params) do
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
end
