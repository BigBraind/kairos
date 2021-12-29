defmodule LifecycleWeb.JourneysLiveTest do
  use LifecycleWeb.ConnCase

  import Phoenix.LiveViewTest
  import Lifecycle.TimelineFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_journeys(_) do
    journeys = journey_fixture()
    %{journeys: journeys}
  end

  describe "Index" do
    setup [:create_journeys]

    test "lists all journeys", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.journeys_index_path(conn, :index))

      assert html =~ "Listing Journeys"
    end

    test "saves new journeys", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.journeys_index_path(conn, :index))

      assert index_live |> element("a", "New Journeys") |> render_click() =~
               "New Journeys"

      assert_patch(index_live, Routes.journeys_index_path(conn, :new))

      assert index_live
             |> form("#journeys-form", journeys: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#journeys-form", journeys: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.journeys_index_path(conn, :index))

      assert html =~ "Journeys created successfully"
    end

    test "updates journeys in listing", %{conn: conn, journeys: journeys} do
      {:ok, index_live, _html} = live(conn, Routes.journeys_index_path(conn, :index))

      assert index_live |> element("#journeys-#{journeys.id} a", "Edit") |> render_click() =~
               "Edit Journeys"

      assert_patch(index_live, Routes.journeys_index_path(conn, :edit, journeys))

      assert index_live
             |> form("#journeys-form", journeys: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#journeys-form", journeys: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.journeys_index_path(conn, :index))

      assert html =~ "Journeys updated successfully"
    end

    test "deletes journeys in listing", %{conn: conn, journeys: journeys} do
      {:ok, index_live, _html} = live(conn, Routes.journeys_index_path(conn, :index))

      assert index_live |> element("#journeys-#{journeys.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#journeys-#{journeys.id}")
    end
  end

  describe "Show" do
    setup [:create_journeys]

    test "displays journeys", %{conn: conn, journeys: journeys} do
      {:ok, _show_live, html} = live(conn, Routes.journeys_show_path(conn, :show, journeys))

      assert html =~ "Show Journeys"
    end

    test "updates journeys within modal", %{conn: conn, journeys: journeys} do
      {:ok, show_live, _html} = live(conn, Routes.journeys_show_path(conn, :show, journeys))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Journeys"

      assert_patch(show_live, Routes.journeys_show_path(conn, :edit, journeys))

      assert show_live
             |> form("#journeys-form", journeys: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#journeys-form", journeys: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.journeys_show_path(conn, :show, journeys))

      assert html =~ "Journeys updated successfully"
    end
  end
end
