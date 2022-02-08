defmodule Lifecycle.MoneyFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Lifecycle.Money` context.
  """

  @doc """
  Generate a billing.
  """
  def billing_fixture(attrs \\ %{}) do
    {:ok, billing} =
      attrs
      |> Enum.into(%{
        amount: 42,
        currency: "some currency",
        email: "some email",
        name: "some name",
        payment_intent_id: "some payment_intent_id",
        payment_method_id: "some payment_method_id",
        status: "some status"
      })
      |> Lifecycle.Money.create_billing()

    billing
  end
end
