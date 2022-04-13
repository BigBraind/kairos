defmodule LifecycleWeb.RealmLive.Show do
  use LifecycleWeb, :live_view

  alias Lifecycle.Users

  @impl true
  def mount(%{"party_name" => party, "realm_name" => realm}, _session, socket) do
    realm_topic = "realm:" <> party <> ":" <> realm
    if connected?(socket), do: Lifecycle.Pubsub.subscribe(realm_topic)
    {:ok,
     socket
     |> assign(:party_name, party)
     |> assign(:realm_topic, realm_topic)
     |> assign(:nowstream, [shitty: "piece opf shit", shittier: "this smells good"])}
  end

  @impl true
  def handle_params(%{"realm_name" => name}, _, socket) do

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:realm, Users.get_realm_by_name!(name))}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:realm, Users.get_realm!(id))}
  end

  @impl true
  def handle_info({Lifecycle.Pubsub, [:echo, :flux], message}, socket) do
    IO.puts("Show is Live")
    IO.inspect(socket.assigns)
    {:noreply,
     socket
     |> assign(:nowstream, [message | socket.assigns.nowstream])
    }
  end

  defp page_title(:show), do: "Show Realm"
  defp page_title(:edit), do: "Edit Realm"
end
