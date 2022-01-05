defmodule LifecycleWeb.Auth.Protocol do
  import LifecycleWeb.Auth.Helpers

  def mount(params, session, socket) do
    %{assigns: assigns} = Helpers.assign_defaults(socket, session)
    IO.inspect(assigns)
    # {:ok, assign(socket, assigns: assigns)}
  end
end
