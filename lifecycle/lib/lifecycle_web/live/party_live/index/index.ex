defmodule LifecycleWeb.PartyLive.Index do
  @moduledoc false

  use LifecycleWeb, :live_view

  alias Lifecycle.Massline
  alias Lifecycle.Pubsub
  alias Lifecycle.Users.Party

  alias LifecycleWeb.Modal.Component.Flash
  alias LifecycleWeb.Modal.Pubsub.PartyPubs

  @impl true
  def mount(_params, _session, socket) do
    IO.inspect(self())
    if connected?(socket), do: Pubsub.subscribe("party:index")

    {:ok,
     assign(socket,
       all_parties: Massline.list_parties(),
       my_parties: Massline.list_my_parties(socket.assigns.current_user.id)
     )}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Let's Party Yooooo")
    |> assign(:party, nil)
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Party")
    |> assign(:current_user, socket.assigns.current_user)
    |> assign(:party, %Party{})
  end

  defp apply_action(socket, :show, _params) do
    socket
    |> assign(:page_title, "Party Time")
  end

  defp apply_action(socket, :edit, %{"party_name" => id}) do
    socket
    |> assign(:page_title, "Edit Party")
    |> assign(:party, Massline.get_party!(id))
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    party = Massline.get_party!(id)
    {:ok, _} = Massline.delete_party(party)

    {:noreply,
     socket
     |> assign(:all_parties, list_party())
     |> Flash.insert_flash(:info, "Party deleted...", self())}
  end

  @impl true
  def handle_info({Pubsub, [:party, :created], message}, socket) do
    PartyPubs.handle_party_created(socket, message)
  end

  @impl true
  def handle_info(:clear_flash, socket), do: Flash.handle_flash(socket)

  defp list_party, do: Massline.list_parties()
end
