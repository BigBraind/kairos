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

  # TODO: Princeton: add any phase information here
  def render(assigns) do
    ~H"""
      <div>
          <h1><%= @phase.title %> </h1>
      </div>
    """
  end
end
