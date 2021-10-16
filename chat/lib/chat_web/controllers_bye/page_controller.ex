defmodule ChatWeb.PageController do
  use ChatWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def journey(conn, _params) do
    render(conn, "journey.html")
  end

end
