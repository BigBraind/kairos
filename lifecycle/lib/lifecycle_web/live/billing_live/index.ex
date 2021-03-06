defmodule LifecycleWeb.BillingLive.Index do
  @moduledoc false
  use LifecycleWeb, :live_view

  alias Lifecycle.Money
  alias Lifecycle.Money.Billing

  alias Stripe.Customer
  alias Stripe.PaymentIntent

  @impl true
  def mount(_params, _session, socket) do
    {
      :ok,
      socket
      |> assign(:changeset, Money.change_billing(%Billing{}))
      |> assign(:checkout, nil)
      |> assign(:intent, nil)
    }
  end

  @impl true
  def handle_event("submitStripe", %{"billing" => billing_params}, socket) do
    case Money.create_billing(billing_params) do
      {:ok, checkout} ->
        send(self(), {:create_payment_intent, checkout}) # Run this async
        {:noreply, assign(socket, checkout: checkout, changeset: Money.change_billing(checkout))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  def handle_event(
        "paymentSuccess",
        %{"payment_method" => payment_method_id, "status" => status},
        socket
      ) do
    checkout = socket.assigns.checkout
    # Update the checkout with the result
    {:ok, checkout} =
      Money.update_billing(checkout, %{payment_method_id: payment_method_id, status: status})

    {:noreply,
     push_redirect(
       socket
       |> put_flash(:info, "Billing Working")
       |> assign(:checkout, checkout),
       to: "/"
     )}
  end

  @impl true
  def handle_info(
        {:create_payment_intent,
         %{email: email, name: name, amount: amount, currency: currency} = checkout},
        socket
      ) do
    with {:ok, stripe_customer} <- Customer.create(%{email: email, name: name}),
         {:ok, payment_intent} <-
           PaymentIntent.create(%{
             customer: stripe_customer.id,
             amount: amount,
             currency: currency
           }) do
      # Update the checkout
      Money.update_billing(checkout, %{payment_intent_id: payment_intent.id})

      {:noreply, assign(socket, :intent, payment_intent)}
    else
      _ ->
        {:noreply, assign(socket, :stripe_error, "There was an error with the stripe")}
    end
  end
end
