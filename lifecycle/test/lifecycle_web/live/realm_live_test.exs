defmodule LifecycleWeb.RealmLiveTest do
  use LifecycleWeb.ConnCase

  import Phoenix.LiveViewTest
  import Lifecycle.UsersFixtures

  @create_attrs %{description: "some description", name: "some name", party_name: "CCP"}
  @update_attrs %{description: "some updated description", name: "some updated name"}
  @invalid_attrs %{description: nil, name: nil}

  defp create_realm(_) do
    realm = realm_fixture()
    %{realm: realm}
  end

  describe "Index" do
    setup [:create_realm]

    test "lists all realms", %{conn: conn, realm: realm} do
      {:ok, _index_live, html} = live(conn, Routes.realm_index_path(conn, :index, realm.party_name))

      assert html =~ "Listing Realms"
      assert html =~ realm.description
    end


    test "updates realm in listing", %{conn: conn, realm: realm} do
      {:ok, index_live, _html} = live(conn, Routes.realm_index_path(conn, :index, realm.party_name))

      assert index_live |> element("#realm-#{realm.id} a", "Edit") |> render_click() =~
               "Edit Realm"

      assert_patch(index_live, Routes.realm_index_path(conn, :edit, realm))

      assert index_live
             |> form("#realm-form", realm: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#realm-form", realm: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.realm_index_path(conn, :index, realm.party_name))

      assert html =~ "Realm updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes realm in listing", %{conn: conn, realm: realm} do
      {:ok, index_live, _html} = live(conn, Routes.realm_index_path(conn, :index, realm.party_name))

      assert index_live |> element("#realm-#{realm.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#realm-#{realm.id}")
    end
  end

end
