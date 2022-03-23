defmodule LifecycleWeb.Modal.View.Button.Approve do
  @moduledoc """
  View of Approve button
  """
  use LifecycleWeb, :live_component

  def button(assigns) do
    ~H"""
      <button phx-click="approve" value={@echo.id}>Fire? 🔥</button>
    """
  end

end
