defmodule LifecycleWeb.Modal.Function.Echoes.EchoHandler do
  @moduledoc """
  Function component of handling send echoes event
  """

  use LifecycleWeb, :live_component

  alias Lifecycle.Pubsub
  alias Lifecycle.Timeline

  alias LifecycleWeb.Modal.Function.Component.Flash
  alias LifecycleWeb.Modal.Function.Pubsub.Pubs

  @doc """
  Handle send echo event
  Publish the msg and
  """
  def send_echo(echo_params, socket) do
    topic = Pubs.get_topic(socket)

    case Timeline.create_echo(echo_params) do
      {:ok, echo} ->
        {Pubsub.notify_subs({:ok, echo}, [:echo, :created], topic)}

        {
          :noreply,
          socket
          |> Flash.insert_flash(:info, "Message Sent", self())
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

end
