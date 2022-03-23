defmodule LifecycleWeb.Modal.View.Button.Transitions do
  @moduledoc """
  Transition button
  """
  use Phoenix.Component

  def button(assigns) do
    ~H"""
      <button phx-click="transition">Drop Beats 🖐🎤</button>
    """
  end
end
