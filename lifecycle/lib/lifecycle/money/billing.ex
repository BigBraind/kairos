defmodule Lifecycle.Money.Billing do
  use Ecto.Schema
  import Ecto.Changeset

  schema "billings" do
    field :amount, :integer
    field :currency, :string
    field :email, :string
    field :name, :string
    field :payment_intent_id, :string
    field :payment_method_id, :string
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(billing, attrs) do
    billing
    |> cast(attrs, [:email, :name, :amount, :currency, :payment_intent_id, :payment_method_id, :status])
    |> validate_required([:email, :name, :amount, :currency])#, :payment_intent_id, :payment_method_id, :status])
  end
end
