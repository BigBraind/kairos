defmodule LifecycleWeb.Modal.Button.Transition do

  use Phoenix.Component

  def button(assigns) do
    ~H"""
      <button phx-click="transition">Add Transition</button>
    """
  end

  def handle_button("transition", socket) do
    {:noreply,
     socket
     |> assign(:transiting, true)}
  end
end
