defmodule ChatWeb.PageControllerTest do
  use ChatWeb.ConnCase
  setup %{conn: conn} do
    user = %Chat.Users.User{email: "stalin@gulag.archipelago", id: 1}
    authed_conn = Pow.Plug.assign_current_user(conn, user, [])

    {:ok, conn: conn, authed_conn: authed_conn}
  end

  test "redirects to show when data is valid", %{authed_conn: authed_conn} do

    conn = get(authed_conn, "/")
    assert html_response(conn, 200) =~ "Putin"
  end

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 302) =~ "redirected"
  end
end
