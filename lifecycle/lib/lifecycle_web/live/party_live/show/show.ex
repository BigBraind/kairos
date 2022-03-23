defmodule LifecycleWeb.PartyLive.Show do
  @moduledoc false

  use LifecycleWeb, :live_view

  alias Lifecycle.Massline
  alias Lifecycle.Pubsub
  alias Lifecycle.Users.Party

  alias LifecycleWeb.Modal.Function.Component.Flash
  alias LifecycleWeb.Modal.Function.Party.PartyEventHandler
  alias LifecycleWeb.Modal.Function.Pubsub.PartyPubs

  @impl true
  def mount(%{"party_name" => name}, _session, socket) do
    parties = get_party_by_name(name)

    if connected?(socket) do
      Pubsub.subscribe("party:" <> parties.id)

      {:ok,
       assign(socket,
         party: parties,
         party_changeset: Party.changeset(%Party{})
       )}
    end

    {:ok,
     assign(socket,
       party: parties,
       party_changeset: Party.changeset(%Party{})
     )}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :show, %{"party_name" => name}) do
    socket
    |> assign(:page_title, "Show Party")
    |> assign(:party, get_party_by_name(name))
  end

  defp apply_action(socket, :edit, %{"party_name" => name}) do
    socket
    |> assign(:page_title, "Edit Party")
    |> assign(:party, get_party_by_name(name))
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    PartyEventHandler.handle_delete_member(socket, id)
  end

  def handle_event("add_member", %{"party" => party_params}, socket) do
    PartyEventHandler.handle_add_member(socket, party_params)
  end

  def handle_event("subtract_member", %{"party" => party_params}, socket) do
    PartyEventHandler.handle_subtract_member(socket, party_params)
  end

  @impl true
  def handle_info({Pubsub, [:member, :added], message}, socket) do
    PartyPubs.handle_member_added(socket, message)
  end

  @impl true
  def handle_info({Pubsub, [:member, :removed], _message}, socket) do
    PartyPubs.handle_member_removed(socket)
  end

  @impl true
  def handle_info(:clear_flash, socket), do: Flash.handle_flash(socket)

  defp get_party_by_name(name), do: Massline.get_party_by_name!(name)
end
