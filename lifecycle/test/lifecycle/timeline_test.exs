defmodule Lifecycle.TimelineTest do
  use Lifecycle.DataCase

  alias Lifecycle.Timeline

  describe "echoes" do
    alias Lifecycle.Timeline.Echo

    import Lifecycle.TimelineFixtures

    @invalid_attrs %{journey: nil, message: nil, name: nil, type: nil}

    test "list_echoes/0 returns all echoes" do
      echo = echo_fixture()
      assert Timeline.list_echoes() == [echo]
    end

    test "get_echo!/1 returns the echo with given id" do
      echo = echo_fixture()
      assert Timeline.get_echo!(echo.id) == echo
    end

    test "create_echo/1 with valid data creates a echo" do
      valid_attrs = %{journey: "some journey", message: "some message", name: "some name", type: "some type"}

      assert {:ok, %Echo{} = echo} = Timeline.create_echo(valid_attrs)
      assert echo.journey == "some journey"
      assert echo.message == "some message"
      assert echo.name == "some name"
      assert echo.type == "some type"
    end

    test "create_echo/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Timeline.create_echo(@invalid_attrs)
    end

    test "update_echo/2 with valid data updates the echo" do
      echo = echo_fixture()
      update_attrs = %{journey: "some updated journey", message: "some updated message", name: "some updated name", type: "some updated type"}

      assert {:ok, %Echo{} = echo} = Timeline.update_echo(echo, update_attrs)
      assert echo.journey == "some updated journey"
      assert echo.message == "some updated message"
      assert echo.name == "some updated name"
      assert echo.type == "some updated type"
    end

    test "update_echo/2 with invalid data returns error changeset" do
      echo = echo_fixture()
      assert {:error, %Ecto.Changeset{}} = Timeline.update_echo(echo, @invalid_attrs)
      assert echo == Timeline.get_echo!(echo.id)
    end

    test "delete_echo/1 deletes the echo" do
      echo = echo_fixture()
      assert {:ok, %Echo{}} = Timeline.delete_echo(echo)
      assert_raise Ecto.NoResultsError, fn -> Timeline.get_echo!(echo.id) end
    end

    test "change_echo/1 returns a echo changeset" do
      echo = echo_fixture()
      assert %Ecto.Changeset{} = Timeline.change_echo(echo)
    end
  end
end
