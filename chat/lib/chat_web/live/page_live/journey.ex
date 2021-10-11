defmodule ChatWeb.PageLive.Journey do
  use Phoenix.LiveView

  # def mount(_session, socket) do

  # end
  def render(assigns)do
    ChatWeb.PageView.render("journey.html",assigns)
  end
end
