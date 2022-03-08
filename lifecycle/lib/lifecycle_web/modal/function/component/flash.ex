defmodule LifecycleWeb.Modal.Function.Component.Flash do
  @moduledoc """
    Handle put flash and clear flash
  """

  use LifecycleWeb, :live_view

  def insert_flash(socket, message, info, parent_id) do
    Process.send_after(parent_id, :clear_flash, 1000)
    socket
    |> put_flash(message, info)
  end

  def handle_flash(socket), do: {:noreply, clear_flash(socket)}

end
