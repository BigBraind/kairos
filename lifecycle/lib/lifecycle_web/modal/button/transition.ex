defmodule LifecycleWeb.Modal.Button.Transition do
  @moduledoc """
  Transition button
  """
  use Phoenix.Component

  def button(assigns) do
    ~H"""
      <button phx-click="transition">Add Beats</button>
    """
  end

  @doc """
  handle event for approve button
  assign transiting to true, such that users can upload image to be approved
  """
  def handle_button("transition", socket) do
    {:noreply,
     socket
     |> assign(:transiting, true)}
  end
end
