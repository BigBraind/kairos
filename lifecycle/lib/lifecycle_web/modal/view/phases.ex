defmodule LifecycleWeb.Modal.View.Transition.Phases do
  @moduledoc false

  use LifecycleWeb, :live_component

  alias Lifecycle.Timeline

  def mount(socket) do
    {:ok, socket}
  end

  def update(%{phase: phase, class: class}, socket) do
    {:ok, assign(socket, phase: phase)}
  end

  defdelegate phase_has_child?(phase_id), to: Timeline

  # TODO: Princeton: add any phase information here
  def render(assigns) do
    ~H"""
      <div>
          <h1><%= @phase.title %> </h1>
          <%= if phase_has_child?(@phase.id) do %>
            <button phx-click="display_child_phase" phx-value-phase_id={@phase.id} class="p-1 button flex bg-blue-500 text-white text-center font-semibold rounded-lg shadow-lg hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-700 focus:ring-opacity-75"> + </button>
          <% end %>
      </div>
    """
  end
end
