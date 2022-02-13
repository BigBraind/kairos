defmodule LifecycleWeb.PartyLive.Show do
  @moduledoc false

  use LifecycleWeb, :live_view

  alias Lifecycle.Users.Party
  alias Lifecycle.Users.User
  alias Lifecycle.Massline


  @impl true
  def mount(%{"party_name" => id} = params, _session, socket) do
    # {:ok, assign(socket, party: get_party(id))}
    {:ok,
    assign(socket,
    party: get_party(id),
    party_changeset: Party.changeset(%Party{}))}
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
    # {:noreply, assign(socket, :all_party, list_party())}
    {:noreply,
      socket
      |> assign(:all_party, list_party)
      |> put_flash(:info, "Party deleted... 😭 ")
      |> push_redirect(to: Routes.party_index_path(socket, :index))}
  end

  def handle_event("add_member", %{"party" => party_params}, socket) do
    party_id = party_params["party_id"]
    case get_user_id(party_params["user_name"]) do
      %User{} = user ->
        IO.inspect user
        party_params =
          party_params
          |> Map.put("role", "pleb")
          |> Map.put("user_id", user.id)

        case add_member(party_params) do
          {:ok, _} ->
            {:noreply, assign(socket, :party, get_party(party_id))}

          {:error, %Ecto.Changeset{} = changeset} ->
            {:noreply, assign(socket, changeset: changeset)}
        end

      {:error, reason} ->
        {:noreply,
          socket
          |> put_flash(:error, reason)}
      end
  end

  def handle_event("subtract_member", %{"party" => party_params}, socket) do
    party_params =
      party_params
      |> Map.put("role", "pleb")
    IO.inspect(party_params)

    {:noreply, socket}
  end

  # Query
  defp get_party(id), do: Massline.get_party!(id)
  defp delete_party(party), do: Massline.delete_party(party)
  defp list_party, do: Massline.list_parties()
  defp add_member(party_params), do: Massline.add_member(party_params)
  defp subtract_member(party_params), do: Massline.subtract_member(party_params)
  defp get_user_id(user_name), do: Massline.get_user_name(user_name)


end
