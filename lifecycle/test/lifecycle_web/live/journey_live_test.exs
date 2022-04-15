defmodule LifecycleWeb.JourneyLiveTest do
  use LifecycleWeb.ConnCase

  import Phoenix.LiveViewTest
  import Lifecycle.RealmFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_journey(_) do
    journey = journey_fixture()
    %{journey: journey}
  end

  describe "Index" do
    setup [:create_journey]

    test "lists all journeys", %{conn: conn, journey: journey} do
      {:ok, _index_live, html} = live(conn, Routes.journey_index_path(conn, :index))

      assert html =~ "Listing Journeys"
      assert html =~ journey.name
    end

    test "saves new journey", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.journey_index_path(conn, :index))

      assert index_live |> element("a", "New Journey") |> render_click() =~
               "New Journey"

      assert_patch(index_live, Routes.journey_index_path(conn, :new))

      assert index_live
             |> form("#journey-form", journey: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#journey-form", journey: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.journey_index_path(conn, :index))

      assert html =~ "Journey created successfully"
      assert html =~ "some name"
    end

    test "updates journey in listing", %{conn: conn, journey: journey} do
      {:ok, index_live, _html} = live(conn, Routes.journey_index_path(conn, :index))

      assert index_live |> element("#journey-#{journey.id} a", "Edit") |> render_click() =~
               "Edit Journey"

      assert_patch(index_live, Routes.journey_index_path(conn, :edit, journey))

      assert index_live
             |> form("#journey-form", journey: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#journey-form", journey: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.journey_index_path(conn, :index))

      assert html =~ "Journey updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes journey in listing", %{conn: conn, journey: journey} do
      {:ok, index_live, _html} = live(conn, Routes.journey_index_path(conn, :index))

      assert index_live |> element("#journey-#{journey.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#journey-#{journey.id}")
    end
  end

  describe "Show" do
    setup [:create_journey]

    test "displays journey", %{conn: conn, journey: journey} do
      {:ok, _show_live, html} = live(conn, Routes.journey_show_path(conn, :show, journey))

      assert html =~ "Show Journey"
      assert html =~ journey.name
    end

    test "updates journey within modal", %{conn: conn, journey: journey} do
      {:ok, show_live, _html} = live(conn, Routes.journey_show_path(conn, :show, journey))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Journey"

      assert_patch(show_live, Routes.journey_show_path(conn, :edit, journey))

      assert show_live
             |> form("#journey-form", journey: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#journey-form", journey: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.journey_show_path(conn, :show, journey))

      assert html =~ "Journey updated successfully"
      assert html =~ "some updated name"
    end
  end
end
