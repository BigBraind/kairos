defmodule LifecycleWeb.RealmLive.Show do
  use LifecycleWeb, :live_view

  alias Lifecycle.Users

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"realm_name" => name}, _, socket) do

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:realm, Users.get_realm_by_name!(name))}
  end

  defp page_title(:show), do: "Show Realm"
  defp page_title(:edit), do: "Edit Realm"
end
