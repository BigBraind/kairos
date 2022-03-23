defmodule Lifecycle.Timeline.PhaseTest do
  use Lifecycle.DataCase

  alias Lifecycle.Timeline.Phase
  import Lifecycle.TimelineFixtures

  alias Ecto.Adapters.SQL.Sandbox

  setup do
    # Explicitly get a connection before each test
    :ok = Sandbox.checkout(Lifecycle.Repo)
  end

  describe "traits" do
    alias Lifecycle.Timeline.Phase.Trait

    import Lifecycle.Timeline.PhaseFixtures

    setup do
      phase = phase_fixture()
      trait = trait_fixture(phase)
      {:ok, phase: phase, trait: trait}
    end

    @invalid_attrs %{name: nil, type: nil, value: nil}

    test "list_traits/0 returns all traits", %{phase: phase, trait: trait} do
      assert Phase.list_traits(phase.id) == [trait]
    end

    test "get_trait!/1 returns the trait with given id", %{phase: phase, trait: trait} do
      assert Phase.get_trait!(phase.id, trait.id) == trait
    end

    test "create_trait/1 with valid data creates a trait",  %{phase: phase} do
      valid_attrs = %{name: "dimsum", type: "txt", value: "some value"}

      assert {:ok, %Trait{} = trait} = Phase.create_trait(valid_attrs, phase)
      assert trait.name == "dimsum"
      assert trait.type == :txt
      assert trait.value == "some value"
    end

    test "create_trait/1 with invalid data returns error changeset", %{phase: phase} do
      assert {:error, %Ecto.Changeset{}} = Phase.create_trait(@invalid_attrs, phase)
    end

    test "update_trait/2 with valid data updates the trait", %{trait: trait} do
      update_attrs = %{name: "some updated name", type: "txt", value: "some updated value"}

      assert {:ok, %Trait{} = trait} = Phase.update_trait(trait, update_attrs)
      assert trait.name == "some updated name"
      assert trait.type == :txt
      assert trait.value == "some updated value"
    end

    test "update_trait/2 with invalid data returns error changeset", %{trait: trait} do
      trait = trait_fixture()
      assert {:error, %Ecto.Changeset{}} = Phase.update_trait(trait, @invalid_attrs)
      assert trait == Phase.get_trait!(trait.phase_id, trait.id)
    end

    test "delete_trait/1 deletes the trait" do
      trait = trait_fixture()
      assert {:ok, %Trait{}} = Phase.delete_trait(trait)
      assert_raise Ecto.NoResultsError, fn -> Phase.get_trait!(trait.phase_id, trait.id) end
    end

    test "change_trait/1 returns a trait changeset" do
      trait = trait_fixture()
      assert %Ecto.Changeset{} = Phase.change_trait(trait)
    end
  end
end
