defmodule LifecycleWeb.RealmLive.FormComponent do
  use LifecycleWeb, :live_component

  alias Lifecycle.Users

  @impl true
  def update(%{realm: realm} = assigns, socket) do
    changeset = Users.change_realm(realm)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"realm" => realm_params}, socket) do
    changeset =
      socket.assigns.realm
      |> Users.change_realm(realm_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"realm" => realm_params}, socket) do
    save_realm(socket, socket.assigns.action, realm_params)
  end

  defp save_realm(socket, :edit, realm_params) do
    case Users.update_realm(socket.assigns.realm, realm_params) do
      {:ok, realm} ->
        return = try do
          socket.assigns.return_to
          rescue
          KeyError -> Routes.realm_show_path(socket, :show, realm.party_name, realm.name)
        end
        {:noreply,
         socket
         |> put_flash(:info, "Realm updated successfully")
         |> push_redirect(to: return)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
     end
  end

  defp save_realm(socket, :new, realm_params) do
    IO.inspect(realm_params)
    case Users.create_realm(realm_params) do
      {:ok, _realm} ->
        {:noreply,
         socket
         |> put_flash(:info, "Realm created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
