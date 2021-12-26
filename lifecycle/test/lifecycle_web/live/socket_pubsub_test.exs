
defmodule LifecycleWeb.SocketPubsubTest do
  use Lifecycle.DataCase
  alias Lifecycle.Pubsub

  alias LifecycleWeb.EchoLive
  import Lifecycle.TimelineFixtures
  import Lifecycle.PubsubFixtures
  use LifecycleWeb, :live_view

  defp create_socket() do
    %{socket: %Phoenix.LiveView.Socket{}}
  end

  describe "Socket state" do
    setup do
      create_socket()
    end

    test "subscribes to echo events and receives an event upon publish", %{socket: socket} do
      socket = assign(socket, nowstream: [])
      IO.inspect(socket)
      echo = echo_fixture()

      %{topic: topic, event: event} = pubsub_fixture()

      if connected?(socket), do: Pubsub.subscribe(topic)

      Pubsub.notify_subs({:ok, echo}, event, topic)

      IO.inspect(socket.assigns.nowstream)
    end
  end

end
