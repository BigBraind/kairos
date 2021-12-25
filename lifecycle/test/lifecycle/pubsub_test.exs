defmodule Lifecycle.PubsubTest do
  alias Lifecycle.Pubsub

  use ExUnit.Case

  describe "pubsub" do
    import Lifecycle.PubsubFixtures

    test "notify_subs/3 publish new msg to topic through an event" do
      %{topic: topic, message: message, event: event} = pubsub_fixture()

      Pubsub.subscribe(topic)
      assert Pubsub.notify_subs({:ok, message}, event, topic) == {:ok, message}
    end

    # test "notify_subs/2 failing to publish new msg to topic" do

    # end

    test "subscribe/1 subscribe to new topic" do
      %{topic: topic} = pubsub_fixture()

      assert Pubsub.subscribe(topic)  == :ok
    end

  end
end
