defmodule LifecycleWeb.PageControllerTest do
  use LifecycleWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Welcome to BigBrain"
  end
end
