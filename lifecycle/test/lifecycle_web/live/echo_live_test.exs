defmodule LifecycleWeb.EchoLiveTest do
  use LifecycleWeb.ConnCase

  import Phoenix.LiveViewTest
  import Lifecycle.TimelineFixtures

  @create_attrs %{journey: "some journey", message: "some message", name: "some name", type: "some type"}
  @update_attrs %{journey: "some updated journey", message: "some updated message", name: "some updated name", type: "some updated type"}
  @invalid_attrs %{journey: nil, message: nil, name: nil, type: nil}

  defp create_echo(_) do
    echo = echo_fixture()
    %{echo: echo}
  end

  describe "Index" do
    setup [:create_echo]

    test "lists all echoes", %{conn: conn, echo: echo} do
      {:ok, _index_live, html} = live(conn, Routes.echo_index_path(conn, :index))

      assert html =~ "Listing Echoes"
      assert html =~ echo.journey
    end

    test "saves new echo", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.echo_index_path(conn, :index))

      assert index_live |> element("a", "New Echo") |> render_click() =~
               "New Echo"

      assert_patch(index_live, Routes.echo_index_path(conn, :new))

      assert index_live
             |> form("#echo-form", echo: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#echo-form", echo: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.echo_index_path(conn, :index))

      assert html =~ "Echo created successfully"
      assert html =~ "some journey"
    end

    test "updates echo in listing", %{conn: conn, echo: echo} do
      {:ok, index_live, _html} = live(conn, Routes.echo_index_path(conn, :index))

      assert index_live |> element("#echo-#{echo.id} a", "Edit") |> render_click() =~
               "Edit Echo"

      assert_patch(index_live, Routes.echo_index_path(conn, :edit, echo))

      assert index_live
             |> form("#echo-form", echo: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#echo-form", echo: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.echo_index_path(conn, :index))

      assert html =~ "Echo updated successfully"
      assert html =~ "some updated journey"
    end

    test "deletes echo in listing", %{conn: conn, echo: echo} do
      {:ok, index_live, _html} = live(conn, Routes.echo_index_path(conn, :index))

      assert index_live |> element("#echo-#{echo.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#echo-#{echo.id}")
    end
  end

  describe "Show" do
    setup [:create_echo]

    test "displays echo", %{conn: conn, echo: echo} do
      {:ok, _show_live, html} = live(conn, Routes.echo_show_path(conn, :show, echo))

      assert html =~ "Show Echo"
      assert html =~ echo.journey
    end

    test "updates echo within modal", %{conn: conn, echo: echo} do
      {:ok, show_live, _html} = live(conn, Routes.echo_show_path(conn, :show, echo))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Echo"

      assert_patch(show_live, Routes.echo_show_path(conn, :edit, echo))

      assert show_live
             |> form("#echo-form", echo: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#echo-form", echo: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.echo_show_path(conn, :show, echo))

      assert html =~ "Echo updated successfully"
      assert html =~ "some updated journey"
    end
  end
end
