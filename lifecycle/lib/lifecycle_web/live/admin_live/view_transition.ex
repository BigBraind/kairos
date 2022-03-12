defmodule LifecycleWeb.AdminLive.ViewTransition do
  @moduledoc false
  use LifecycleWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
      socket
    }
  end

end
