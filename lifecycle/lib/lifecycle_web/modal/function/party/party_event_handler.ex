defmodule LifecycleWeb.Modal.Function.Party.PartyEventHandler do
  @moduledoc """
    function component for event handler for party form event
  """

  use LifecycleWeb, :live_view

  alias Lifecycle.Bridge.Membership
  alias Lifecycle.Massline
  alias Lifecycle.Pubsub

  alias LifecycleWeb.Modal.Function.Component.Flash
  alias LifecycleWeb.Modal.Function.Pubsub.PartyPubs

  @doc """
  Handle delete meember event
  """
  def handle_delete_member(socket, id) do
    party = Massline.get_party!(id)
    {:ok, _} = Massline.delete_party(party)

    {:noreply,
     socket
     |> assign(:all_parties, Massline.list_parties())
     |> Flash.insert_flash(:info, "Party deleted... 😭 ", self())
     |> push_redirect(to: Routes.party_index_path(socket, :index))}
  end

  @doc """
  Handle add member event
  """
  def handle_add_member(socket, party_params) do
    party_params = Map.put(party_params, "role", "pleb")

    topic = PartyPubs.get_topic(socket)

    case Massline.add_member(party_params) do
      # happy case
      {:ok, %Membership{} = membership} ->
        {Pubsub.notify_subs({:ok, membership}, [:member, :added], topic)}

        {:noreply,
         socket
         |> Flash.insert_flash(:info, "member added", self())}

      # handle adding duplcate member to the party
      {:error, %Ecto.Changeset{} = changeset} ->
        # Process.send_after(self(), :clear_flash, 3000)
        {:noreply,
         socket
         |> assign(:changeset, changeset)
         |> Flash.insert_flash(:info, "member already in party", self())}

      # handle the user not found error from massline.get_user_by_name
      # please leave this function at the end of the case statement, or
      # it will overwrite the %Ecto.Changeset
      {:error, reason} ->
        {:noreply,
         socket
         |> Flash.insert_flash(:error, reason, self())}
    end
  end

  @doc """
  handle subtract member event
  """
  def handle_subtract_member(socket, party_params) do
    topic = PartyPubs.get_topic(socket)

    case Massline.subtract_member(party_params) do
      {:ok, message} ->
        {Pubsub.notify_subs({:ok, message}, [:member, :removed], topic)}

        {:noreply,
         socket
         |> Flash.insert_flash(:info, message, self())}

      {:error, reason} ->
        {:noreply,
         socket
         |> Flash.insert_flash(:error, reason, self())}
    end
  end
end
