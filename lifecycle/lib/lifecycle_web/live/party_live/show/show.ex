defmodule LifecycleWeb.PartyLive.Show do
  @moduledoc false

  use LifecycleWeb, :live_view

  alias Lifecycle.Users.Party
  alias Lifecycle.Users.User
  alias Lifecycle.Bridge.Membership

  alias Lifecycle.Pubsub
  alias Lifecycle.Massline

  alias LifecycleWeb.Modal.Pubsub.PartyPubs

  @impl true
  def mount(%{"party_name" => id}, _session, socket) do
    if connected?(socket), do: Pubsub.subscribe("party:" <> id)

    {:ok,
     assign(socket,
       party: get_party(id),
       party_changeset: Party.changeset(%Party{})
     )}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :show, %{"party_name" => id}) do
    socket
    |> assign(:page_title, "Show Party")
    |> assign(:party, get_party(id))
  end

  defp apply_action(socket, :edit, %{"party_name" => id}) do
    socket
    |> assign(:page_title, "Edit Party")
    |> assign(:party, get_party(id))
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    party = get_party(id)
    {:ok, _} = delete_party(party)

    {:noreply,
     socket
     |> assign(:all_parties, list_party)
     |> put_flash(:info, "Party deleted... 😭 ")
     |> push_redirect(to: Routes.party_index_path(socket, :index))}
  end

  def handle_event("add_member", %{"party" => party_params}, socket) do
    party_id = party_params["party_id"]

    party_params = Map.put(party_params, "role", "pleb")

    topic = PartyPubs.get_topic(socket)

    case Massline.add_member(party_params) do
      {:ok, %Membership{} = membership} ->
        {Pubsub.notify_subs({:ok, membership}, [:member, :added], topic)}


        {:noreply,
         socket
         |> put_flash(:info, "member added")
        }

      nil ->
        {:noreply,
         socket
         |> put_flash(:error, "user not found")}

      {:error, reason} ->
        {:noreply,
         socket
         |> put_flash(:error, reason)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  def handle_event("subtract_member", %{"party" => party_params}, socket) do
    IO.inspect("from handle_event substract member")
    party_id = party_params["party_id"]
    topic = PartyPubs.get_topic(socket)

    case subtract_member(party_params) do
      {:ok, message} ->
        {IO.inspect("from ok msg")}
        {Pubsub.notify_subs({:ok, message}, [:member, :removed], topic)}

        {:noreply,
         socket
        #  |> assign(:party, get_party(party_id))
         |> put_flash(:info, message)}

      {:error, reason} ->
        {:noreply,
         socket
         |> put_flash(:error, reason)}
    end
  end

  @impl true
  def handle_info({Pubsub, [:member, :added], message}, socket) do
    PartyPubs.handle_member_added(socket, message)
  end

  @impl true
  def handle_info({Pubsub, [:member, :removed], message}, socket) do
    PartyPubs.handle_member_removed(socket, message)
  end

  # Query
  defp get_party(id), do: Massline.get_party!(id)
  defp delete_party(party), do: Massline.delete_party(party)
  defp list_party, do: Massline.list_parties()
  defp get_user_id(user_name), do: Massline.get_user_by_name(user_name)
  defp add_member(party_params), do: Massline.add_member(party_params)
  defp subtract_member(party_params), do: Massline.subtract_member(party_params)
end
