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


    @invalid_attrs %{journey_id: nil, message: nil, name: nil, type: nil}

    test "list_echoes/0 returns all echoes" do
      echo = echo_fixture()
      IO.inspect echo
      assert Timeline.list_echoes() == [echo]
    end

    test "get_echo!/1 returns the echo with given id" do
      echo = echo_fixture()
      IO.inspect echo
      assert Timeline.get_echo!(echo.id) == echo
    end

    test "create_echo/1 with valid data and pre-existing journey creates a echo" do
      %{journey_id: journey_id} = journey_fixture()
      valid_attrs = %{journey_id: journey_id, message: "some message", name: "some name"}

      assert {:ok, %Echo{} = echo} = Timeline.create_echo(valid_attrs)
      IO.inspect journey_id
      IO.inspect echo
      assert echo.journey_id == journey_id
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
      #assert echo.journey == "some updated journey"
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

  # describe "journey" do
  #   alias Lifecycle.Timeline.Journey
  #   @invalid_attrs %{journey_type: nil, journey_id: nil, journey_title: nil, journey_content: nil}

  #   test "list_journeys/0 returns all echoes" do
  #     echo = echo_fixture()
  #     assert Timeline.list_echoes() == [echo]
  #   end

  #   test "create_journey/1 with valid data creates a journey"
  #   valid_attrs = %{
  #     journey_content: "testContent",
  #     journey_id: "2e119489-61fb-4bfe-a7b5-3f9a9d11756e",
  #     journey_title: "testTitle",
  #     journey_type: "testType"
  #   }
  #   assert {:ok, %Journey{} = journey} = Timeline.create_journey(valid_attrs)


  # end


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
