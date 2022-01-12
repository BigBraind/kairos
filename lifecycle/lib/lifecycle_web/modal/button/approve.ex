defmodule LifecycleWeb.Modal.Button.Approve do
  use LifecycleWeb, :live_component

  alias Lifecycle.Timeline
  alias Lifecycle.Timeline.Echo

  alias Lifecycle.Pubsub

  def button(assigns) do
    ~H"""
      <button phx-click="approve" value={@echo.id}>Approve?</button>
    """
  end

  def handle_button(%{"value" => id}, socket) do
    echo = Timeline.get_echo!(id)

    case echo.transited do
      false ->
        {
          echo_params = %{
            transited: true,
            transiter: socket.assigns.current_user.name
          }
        }

        case Timeline.update_transition(id, echo_params) do
          {:ok, echo} ->
            # to be handled by `handle_info` in EchoLive/index.ex
            {Pubsub.notify_subs({:ok, echo}, [:transition, :approved], "1")}

            {:noreply,
             socket
             |> put_flash(:info, "Transition approved!")}

          {:error, %Ecto.Changeset{} = changeset} ->
            {:noreply, assign(socket, :changeset, changeset)}
        end

      true ->
        {
          :noreply,
          socket
          |> put_flash(:info, "Transition already approved!")
        }
    end
  end
end
