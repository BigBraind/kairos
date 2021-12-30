defmodule LifecycleWeb.PhaseLiveTest do
  use LifecycleWeb.ConnCase

  import Phoenix.LiveViewTest
  import Lifecycle.TimelineFixtures

  @create_attrs %{content: "some content", title: "some title", type: "some type"}
  @update_attrs %{content: "some updated content", title: "some updated title", type: "some updated type"}
  @invalid_attrs %{content: nil, title: nil, type: nil}

  defp create_phase(_) do
    phase = phase_fixture()
    %{phase: phase}
  end

  describe "Index" do
    setup [:create_phase]

    test "lists all phases", %{conn: conn, phase: phase} do
      {:ok, _index_live, html} = live(conn, Routes.phase_index_path(conn, :index))

      assert html =~ "Listing Phases"
      assert html =~ phase.content
    end

    test "creates new phase", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.phase_index_path(conn, :index))

      assert index_live |> element("a", "New Phase") |> render_click() =~
               "New Phase"

      assert_patch(index_live, Routes.phase_index_path(conn, :new))
    end

    test "updates phase in listing", %{conn: conn, phase: phase} do
      {:ok, index_live, _html} = live(conn, Routes.phase_index_path(conn, :index))

      assert index_live |> element("#phase-#{phase.id} a", "Edit") |> render_click() =~
               "Edit Phase"

      assert_patch(index_live, Routes.phase_index_path(conn, :edit, phase))

      assert index_live
             |> form("#phase-form", phase: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#phase-form", phase: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.phase_index_path(conn, :index))

      assert html =~ "Phase updated successfully"
      assert html =~ "some updated content"
    end

    test "deletes phase in listing", %{conn: conn, phase: phase} do
      {:ok, index_live, _html} = live(conn, Routes.phase_index_path(conn, :index))

      assert index_live |> element("#phase-#{phase.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#phase-#{phase.id}")
    end
  end

  describe "Show" do
    setup [:create_phase]

    test "displays phase", %{conn: conn, phase: phase} do
      {:ok, _show_live, html} = live(conn, Routes.phase_show_path(conn, :show, phase))

      assert html =~ "Show Phase"
      assert html =~ phase.content
    end

    test "updates phase within modal", %{conn: conn, phase: phase} do
      {:ok, show_live, _html} = live(conn, Routes.phase_show_path(conn, :show, phase))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Phase"

      assert_patch(show_live, Routes.phase_show_path(conn, :edit, phase))

      assert show_live
             |> form("#phase-form", phase: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#phase-form", phase: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.phase_show_path(conn, :show, phase))

      assert html =~ "Phase updated successfully"
      assert html =~ "some updated content"
    end
  end
end
