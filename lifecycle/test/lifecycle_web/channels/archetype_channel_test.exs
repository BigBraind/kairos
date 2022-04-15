defmodule LifecycleWeb.ArchetypeChannelTest do
  use LifecycleWeb.ChannelCase
  import Lifecycle.UsersFixtures

  setup do
    realm_fixture()
    {:ok, _, socket} =
      LifecycleWeb.UserSocket
      |> socket("user_id", %{some: :assign})
      |> subscribe_and_join(LifecycleWeb.ArchetypeChannel, "archetype:realm:42")

    %{socket: socket}
  end

  test "ping replies with status ok", %{socket: socket} do
    ref = push(socket, "ping", %{"hello" => "there"})
    assert_reply ref, :ok, %{"hello" => "there"}
  end

  test "shout broadcasts to archetype:realm", %{socket: socket} do
    push(socket, "echo", %{"hello" => "all"})
    assert_broadcast "echo", %{"hello" => "all"}
  end


  test "broadcasts are pushed to the client", %{socket: socket} do
    broadcast_from!(socket, "broadcast", %{"some" => "data"})
    assert_push "broadcast", %{"some" => "data"}
  end
end
