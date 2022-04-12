defmodule Lifecycle.UsersTest do
  use Lifecycle.DataCase

  alias Lifecycle.Users

  describe "realms" do
    alias Lifecycle.Users.Realm

    import Lifecycle.UsersFixtures

    @invalid_attrs %{description: nil, name: nil}

    test "list_realms/0 returns all realms" do
      realm = realm_fixture()
      assert Users.list_realms() == [realm]
    end

    test "get_realm!/1 returns the realm with given id" do
      realm = realm_fixture()
      assert Users.get_realm!(realm.id) == realm
    end

    test "create_realm/1 with valid data creates a realm" do
      valid_attrs = %{description: "some description", name: "some name"}

      assert {:ok, %Realm{} = realm} = Users.create_realm(valid_attrs)
      assert realm.description == "some description"
      assert realm.name == "some name"
    end

    test "create_realm/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create_realm(@invalid_attrs)
    end

    test "update_realm/2 with valid data updates the realm" do
      realm = realm_fixture()
      update_attrs = %{description: "some updated description", name: "some updated name"}

      assert {:ok, %Realm{} = realm} = Users.update_realm(realm, update_attrs)
      assert realm.description == "some updated description"
      assert realm.name == "some updated name"
    end

    test "update_realm/2 with invalid data returns error changeset" do
      realm = realm_fixture()
      assert {:error, %Ecto.Changeset{}} = Users.update_realm(realm, @invalid_attrs)
      assert realm == Users.get_realm!(realm.id)
    end

    test "delete_realm/1 deletes the realm" do
      realm = realm_fixture()
      assert {:ok, %Realm{}} = Users.delete_realm(realm)
      assert_raise Ecto.NoResultsError, fn -> Users.get_realm!(realm.id) end
    end

    test "change_realm/1 returns a realm changeset" do
      realm = realm_fixture()
      assert %Ecto.Changeset{} = Users.change_realm(realm)
    end
  end
end
