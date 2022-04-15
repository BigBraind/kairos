defmodule LifecycleWeb.ArchetypeChannel do
  use LifecycleWeb, :channel

  alias Lifecycle.Users
  alias Lifecycle.Users.Realm
  @impl true
  def join("archetype:realm:" <> name , payload, socket) do
    if authorized?(payload) do
      realm_topic = case realm= Users.get_realm_by_name!(name) do
                %Realm{:name => realm, :party_name => party} ->
                        "realm:" <> party <> ":" <> realm
                  {:error, reason} ->
                  {:error, reason}
              end
      {:ok, socket
      |> assign(:realm, realm)
      |> assign(:realm_topic, realm_topic)
      }
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (phase:lobby).
  @impl true
  def handle_in("echo", payload, socket) do
    Lifecycle.Pubsub.notify_subs({:ok, payload}, [:echo, :flux], socket.assigns.realm_topic)
    broadcast(socket, "echo", payload)
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
