defmodule Lifecycle.RealmTest do
  use Lifecycle.DataCase

  alias Lifecycle.Realm

  describe "journeys" do
    alias Lifecycle.Realm.Journey

    import Lifecycle.RealmFixtures

    @invalid_attrs %{name: nil}

    test "list_journeys/0 returns all journeys" do
      journey = journey_fixture()
      #assert Realm.list_journeys() == [journey]
    end

    test "get_journey!/1 returns the journey with given id" do
      journey = journey_fixture()
      assert Realm.get_journey!(journey.id) == journey
    end

    test "create_journey/1 with valid data creates a journey" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Journey{} = journey} = Realm.create_journey(valid_attrs)
      assert journey.name == "some name"
    end

    test "create_journey/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Realm.create_journey(@invalid_attrs)
    end

    test "update_journey/2 with valid data updates the journey" do
      journey = journey_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Journey{} = journey} = Realm.update_journey(journey, update_attrs)
      assert journey.name == "some updated name"
    end

    test "update_journey/2 with invalid data returns error changeset" do
      journey = journey_fixture()
      assert {:error, %Ecto.Changeset{}} = Realm.update_journey(journey, @invalid_attrs)
      assert journey == Realm.get_journey!(journey.id)
    end

    test "delete_journey/1 deletes the journey" do
      journey = journey_fixture()
      assert {:ok, %Journey{}} = Realm.delete_journey(journey)
      assert_raise Ecto.NoResultsError, fn -> Realm.get_journey!(journey.id) end
    end

    test "change_journey/1 returns a journey changeset" do
      journey = journey_fixture()
      assert %Ecto.Changeset{} = Realm.change_journey(journey)
    end
  end
end
