defmodule LifecycleWeb.EchoLiveTest do
  use LifecycleWeb.ConnCase

  import Phoenix.LiveViewTest
  import Lifecycle.TimelineFixtures
  import Lifecycle.PubsubFixtures

  alias Lifecycle.Pubsub

  import ExUnit.CaptureLog
  require Logger

  @create_attrs %{message: "some message", name: "some name"}
  @update_attrs %{
    journey: "some updated journey",
    message: "some updated message",
    name: "some updated name",
    type: "some updated type"
  }
  @invalid_attrs %{message: nil, name: nil}

  defp create_echo(_) do
    echo = echo_fixture()
    %{echo: echo}
  end

  describe "Index" do
    setup [:create_echo]

    test "lists all echoes", %{conn: conn, echo: echo} do
      {:ok, _index_live, html} = live(conn, Routes.echo_index_path(conn, :index))

      assert html =~ "Echo History"
      assert html =~ echo.message
    end

    test "saves new echo", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.echo_index_path(conn, :index))

      assert index_live
             |> element("form")
             |> render_submit(echo: @invalid_attrs) =~ "can&#39;t be blank"

      {:ok, index_live, _html} = live(conn, Routes.echo_index_path(conn, :index))

      assert index_live
             |> element("form")
             |> render_submit(echo: @create_attrs) =~ "Message Sent"
    end
  end

  describe "Show" do
    setup [:create_echo]

    test "displays echo", %{conn: conn, echo: echo} do
      {:ok, _show_live, html} = live(conn, Routes.echo_show_path(conn, :show, echo))

      assert html =~ "Show Echo"
      assert html =~ echo.message
    end
  end
end
