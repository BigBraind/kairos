defmodule LifecycleWeb.PartyLive.FormComponent do
  @moduledoc false

  use LifecycleWeb, :live_component

  alias Lifecycle.Pubsub
  alias Lifecycle.Massline

  @impl true
  def update(%{party: party} = assigns, socket) do
    changeset = Massline.change_party(party)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"party" => party_params}, socket) do
    changeset =
      socket.assigns.party
      |> Massline.change_party(party_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"party" => party_params}, socket) do
    save_party(socket, socket.assigns.action, party_params)
  end

  defp save_party(socket, :new, party_params) do
    party_params =
    party_params
    |> Map.put("founder_id", socket.assigns.current_user.id)

    case Massline.create_party(party_params) do
      {:ok, party} ->
        {Pubsub.notify_subs({:ok, party}, [:party, :created], "party:index")}
        
        {:noreply,
          socket
          |> put_flash(:info, "Party created successfully! :)")
          |> push_redirect(to: Routes.party_show_path(socket, :show, party.id))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp save_party(socket, :edit, party_params) do
    case Massline.update_party(socket.assigns.party, party_params) do
      {:ok, _party} ->
        {:noreply,
         socket
         |> put_flash(:info, "Party updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

end
