defmodule LifecycleWeb.Modal.Pubsub.Pubs do
  @moduledoc """
    handle pubs
  """
  use Phoenix.Component

  alias Lifecycle.Timeline.Echo

  def handle_echo_created(socket, message) do
    {:noreply,
     socket
     |> assign(:nowstream, [message | socket.assigns.nowstream])}
  end

  def handle_transition_approved(socket, message) do
    params = %{
      id: message.id,
      transiter: message.transiter,
      echo_stream: :placeholder,
      socket: socket
    }

    {:noreply,
     socket
     |> assign(:nowstream, replace_echoes(%{params | echo_stream: :nowstream}))
     |> assign(:echoes, replace_echoes(%{params | echo_stream: :echoes}))}
  end

  defp replace_echoes(%{
         id: transition_id,
        #  transiter: transiter,
         # list of [:nowstream, :echoes]
         echo_stream: echo_stream,
         socket: socket
       }) do
    # pass back :ok, or :cont

    # looping through the socket.assigns.echoes/nowstream echoes object, then find the approved transition object to be updated
    # Enum.map(socket.assigns[echo_stream], fn
    #   %Echo{id: id} = echo ->
    #     if id == transition_id do
    #       %Echo{echo | transiter: transiter, transited: true}
    #     else
    #       echo
    #     end
    # end)
  end

  def get_topic(socket) do
    if Map.has_key?(socket.assigns, :phase) do
      "phase:" <> socket.assigns.phase.id
    else
      "1"
    end
  end
end
