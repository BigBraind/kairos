defmodule LifecycleWeb.Modal.View.Button.Transitions do
  @moduledoc """
  Transition button
  """
  use Phoenix.Component

  # ! no longer in use
  # FIXME Remove this part and the relevant button action

  def button(assigns) do
    ~H"""
      <button phx-click="transition">Drop Beats 🖐🎤</button>
    """
  end
end
