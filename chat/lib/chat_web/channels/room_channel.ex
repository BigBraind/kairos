defmodule ChatWeb.RoomChannel do
  require Logger
  use ChatWeb, :channel

  @impl true
  def join("journey:" <> _phase, payload, socket) do
    if authorized?(payload) do
      Logger.info payload
      send(self(), :after_join)
      {:ok, socket}
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
  # broadcast to everyone in the current topic (room:lobby).
  @impl true
  def handle_in("shout", payload, socket) do
    Chat.Echo.changeset(%Chat.Echo{}, payload) |> Chat.Repo.insert
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  @impl true
  def handle_info(:after_join,  socket) do
    Logger.info socket.topic
    Chat.Echo.journey_call(socket.topic)
    |> Enum.each(fn echos -> push(socket, "shout", %{
                                         name: echos.name,
                                         message: echos.message,
                                 }) end)
    {:noreply,socket}
  end

  # Add authorization logic here as required.
  # create internal journey centered authorisation library
  # tag guardian token system for shielding apis
  defp authorized?(_payload) do
    true
  end
 end
