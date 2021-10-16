defmodule ChatWeb.JourneyController do
  use ChatWeb, :controller

  def show(conn, %{"id" => journey}) do
    render(conn, "journey.html", journey: journey )
  end
end
