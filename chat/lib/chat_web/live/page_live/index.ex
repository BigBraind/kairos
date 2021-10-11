defmodule ChatWeb.PageLive.Index do
  use Phoenix.LiveView

  # def mount(_session, socket) do

  # end
  def render(assigns)do
    ChatWeb.PageView.render("index.html",assigns)
  end
end
