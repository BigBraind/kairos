defmodule LifecycleWeb.Modal.Function.Pubsub.PartyPubs do
  @moduledoc """
    Function component to handle party pubs
  """

  use Phoenix.Component

  alias Lifecycle.Massline

  @doc """
    Handle create new party event at PartyLive.Index
  """
  def handle_party_created(socket) do
    {:noreply, assign(socket, all_parties: Massline.list_parties())}
  end

  @doc """
    Handle added new member for party
  """
  def handle_member_added(socket, message) do
    party_id = message.party_id
    {:noreply, assign(socket, :party, Massline.get_party!(party_id))}
  end

  @doc """
    Handle removed member for party
  """
  def handle_member_removed(socket) do
    {:noreply, assign(socket, :party, Massline.get_party!(socket.assigns.party.id))}
  end

  @doc """
    Get the topic of the phase from the socket
  """
  def get_topic(socket) do
    if Map.has_key?(socket.assigns, :party), do: "party:" <> socket.assigns.party.id
  end

end
