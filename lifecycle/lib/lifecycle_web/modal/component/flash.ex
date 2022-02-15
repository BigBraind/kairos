defmodule LifecycleWeb.Modal.Component.Flash do
  @moduledoc """
    Handle put flash and clear flash
  """

  use LifecycleWeb, :live_view

  def insert_flash(socket, message, info, parent_id) do
    IO.puts("listening to the greatness of Dragon")
    IO.inspect(parent_id)
    IO.inspect(socket.root_pid)
    IO.inspect(socket.parent_pid)
    Process.send_after(parent_id, :clear_flash, 1000)
    socket
    |> put_flash(message, info)
  end

  def handle_flash(socket), do: {:noreply, clear_flash(socket)}

end
