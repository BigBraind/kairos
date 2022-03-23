defmodule Lifecycle.MoneyTest do
  @moduledoc """
  Test for billing
  """
  use Lifecycle.DataCase

  alias Lifecycle.Money

  describe "billings" do
    alias Lifecycle.Money.Billing

    import Lifecycle.MoneyFixtures

    @invalid_attrs %{
      amount: nil,
      currency: nil,
      email: nil,
      name: nil,
      payment_intent_id: nil,
      payment_method_id: nil,
      status: nil
    }

    test "list_billings/0 returns all billings" do
      billing = billing_fixture()
      assert Money.list_billings() == [billing]
    end

    test "get_billing!/1 returns the billing with given id" do
      billing = billing_fixture()
      assert Money.get_billing!(billing.id) == billing
    end

    test "create_billing/1 with valid data creates a billing" do
      valid_attrs = %{
        amount: 42,
        currency: "some currency",
        email: "some email",
        name: "some name",
        payment_intent_id: "some payment_intent_id",
        payment_method_id: "some payment_method_id",
        status: "some status"
      }

      assert {:ok, %Billing{} = billing} = Money.create_billing(valid_attrs)
      assert billing.amount == 42
      assert billing.currency == "some currency"
      assert billing.email == "some email"
      assert billing.name == "some name"
      assert billing.payment_intent_id == "some payment_intent_id"
      assert billing.payment_method_id == "some payment_method_id"
      assert billing.status == "some status"
    end

    test "create_billing/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Money.create_billing(@invalid_attrs)
    end

    test "update_billing/2 with valid data updates the billing" do
      billing = billing_fixture()

      update_attrs = %{
        amount: 43,
        currency: "some updated currency",
        email: "some updated email",
        name: "some updated name",
        payment_intent_id: "some updated payment_intent_id",
        payment_method_id: "some updated payment_method_id",
        status: "some updated status"
      }

      assert {:ok, %Billing{} = billing} = Money.update_billing(billing, update_attrs)
      assert billing.amount == 43
      assert billing.currency == "some updated currency"
      assert billing.email == "some updated email"
      assert billing.name == "some updated name"
      assert billing.payment_intent_id == "some updated payment_intent_id"
      assert billing.payment_method_id == "some updated payment_method_id"
      assert billing.status == "some updated status"
    end

    test "update_billing/2 with invalid data returns error changeset" do
      billing = billing_fixture()
      assert {:error, %Ecto.Changeset{}} = Money.update_billing(billing, @invalid_attrs)
      assert billing == Money.get_billing!(billing.id)
    end

    test "delete_billing/1 deletes the billing" do
      billing = billing_fixture()
      assert {:ok, %Billing{}} = Money.delete_billing(billing)
      assert_raise Ecto.NoResultsError, fn -> Money.get_billing!(billing.id) end
    end

    test "change_billing/1 returns a billing changeset" do
      billing = billing_fixture()
      assert %Ecto.Changeset{} = Money.change_billing(billing)
    end
  end
end
