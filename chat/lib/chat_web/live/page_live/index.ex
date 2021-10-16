defmodule ChatWeb.PageLive.Index do
  use Phoenix.LiveView
  #use ChatWeb, :live_view

  @impl true
  def mount(_params, _sessions, socket) do
    # socket = assign(socket)
    {:ok, assign(socket, query: "", results: %{})}
  end

  @impl true
  def render(assigns) do
    Phoenix.View.render(ChatWeb.PageView, "index.html", assigns)
  end
end
