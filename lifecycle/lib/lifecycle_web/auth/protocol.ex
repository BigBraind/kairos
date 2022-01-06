defmodule LifecycleWeb.Auth.Protocol do
  @moduledoc """
    Auth.Protocol assigns the current user infomation into socket
    the information can be accessed in Socket.assigns.user_info
    Information accessible includes:
    1. name
    2. id
    3. created_at
  """
  import Phoenix.LiveView
  alias LifecycleWeb.Auth.Helpers

  def on_mount(:auth, _params, session, socket) do
    %{assigns: assigns} = Helpers.assign_defaults(socket, session)
    {:cont, assign(socket, user_info: assigns)}
  end
end
