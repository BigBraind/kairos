defmodule Lifecycle.TimelineTest do
  use Lifecycle.DataCase
  alias Lifecycle.Timeline
  import Lifecycle.TimelineFixtures
  setup do
        # Explicitly get a connection before each test
        :ok = Ecto.Adapters.SQL.Sandbox.checkout(Lifecycle.Repo)
      end


  describe "echoes" do
    alias Lifecycle.Timeline.Echo


    @invalid_attrs %{phase_id: nil, message: nil, name: nil, type: nil}

    test "list_echoes/0 returns all echoes" do
      echo = echo_fixture()
      assert Timeline.list_echoes() == [echo]
    end

    test "get_echo!/1 returns the echo with given id" do
      echo = echo_fixture()
      assert Timeline.get_echo!(echo.id) == echo
    end

    test "create_echo/1 with valid data and pre-existing phase creates a echo" do
      %{id: phase_id} = phase_fixture()
      valid_attrs = %{phase_id: phase_id, message: "some message", name: "some name"}
      assert {:ok, %Echo{} = echo} = Timeline.create_echo(valid_attrs)
      assert echo.phase_id == phase_id
      assert echo.message == "some message"
      assert echo.name == "some name"
      # assert echo.type == "some type"
    end

    test "create_echo/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Timeline.create_echo(@invalid_attrs)
    end

    test "update_echo/2 with valid data updates the echo" do
      echo = echo_fixture()
      update_attrs = %{ message: "some updated message", name: "some updated name"}

      assert {:ok, %Echo{} = echo} = Timeline.update_echo(echo, update_attrs)
      #assert echo.phase == "some updated phase"
      assert echo.message == "some updated message"
      assert echo.name == "some updated name"
      #assert echo.type == "some updated type"
    end

    test "update_echo/2 with invalid data returns error changeset" do
      echo = echo_fixture()
      assert {:error, %Ecto.Changeset{}} = Timeline.update_echo(echo, @invalid_attrs)
      assert echo == Timeline.get_echo!(echo.id)
    end

    test "change_echo/1 returns a echo changeset" do
      echo = echo_fixture()
      assert %Ecto.Changeset{} = Timeline.change_echo(echo)
    end
  end


  describe "phases" do
    alias Lifecycle.Timeline.Phase

    import Lifecycle.TimelineFixtures

    @invalid_attrs %{content: nil, title: nil, type: nil}

    test "list_phases/0 returns all phases" do
      phase = phase_fixture()
      assert Timeline.list_phases() == [phase]
    end

    test "get_phase!/1 returns the phase with given id" do
      phase = phase_fixture()
      assert Timeline.get_phase!(phase.id) == phase
    end

    test "create_phase/1 with valid data creates a phase" do
      valid_attrs = %{content: "some content", title: "some title", type: "some type"}

      assert {:ok, %Phase{} = phase} = Timeline.create_phase(valid_attrs)
      assert phase.content == "some content"
      assert phase.title == "some title"
      assert phase.type == "some type"
    end

    test "create_phase/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Timeline.create_phase(@invalid_attrs)
    end

    test "update_phase/2 with valid data updates the phase" do
      phase = phase_fixture()
      update_attrs = %{content: "some updated content", title: "some updated title", type: "some updated type"}

      assert {:ok, %Phase{} = phase} = Timeline.update_phase(phase, update_attrs)
      assert phase.content == "some updated content"
      assert phase.title == "some updated title"
      assert phase.type == "some updated type"
    end

    test "update_phase/2 with invalid data returns error changeset" do
      phase = phase_fixture()
      assert {:error, %Ecto.Changeset{}} = Timeline.update_phase(phase, @invalid_attrs)
      assert phase == Timeline.get_phase!(phase.id)
    end

    test "delete_phase/1 deletes the phase" do
      phase = phase_fixture()
      assert {:ok, %Phase{}} = Timeline.delete_phase(phase)
      assert_raise Ecto.NoResultsError, fn -> Timeline.get_phase!(phase.id) end
    end

    test "change_phase/1 returns a phase changeset" do
      phase = phase_fixture()
      assert %Ecto.Changeset{} = Timeline.change_phase(phase)
    end
  end
end
