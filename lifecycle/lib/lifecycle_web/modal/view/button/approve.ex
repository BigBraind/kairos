defmodule LifecycleWeb.Modal.View.Button.Approve do
  @moduledoc """
  View of Approve button
  """
  use LifecycleWeb, :live_component

  def button(assigns) do
    ~H"""
      <button phx-click="approve" value={@echo.id}>Fire? 🔥</button>
    """
  end

  # @doc """
  # handle event for approve button
  # update the transition state by changing the
  #   transited: true,
  #   transiter: %User{}

  # notify by pub sub
  # """
  # def handle_button(%{"value" => id}, topic, socket) do
  #   echo = Timeline.get_echo!(id)

  #   case echo.transited do
  #     false ->
  #       {
  #         echo_params = %{
  #           transited: true,
  #           transiter: socket.assigns.current_user.name
  #         }
  #       }

  #       case Timeline.update_transition(id, echo_params) do
  #         {:ok, echo} ->
  #           # to be handled by `handle_info` in EchoLive/index.ex
  #           {Pubsub.notify_subs({:ok, echo}, [:transition, :approved], topic)}

  #           {:noreply,
  #            socket
  #            |> Flash.insert_flash(:info, "Transition approved!", self())}

  #         {:error, %Ecto.Changeset{} = changeset} ->
  #           {:noreply, assign(socket, :changeset, changeset)}
  #       end

  #     true ->
  #       {
  #         :noreply,
  #         socket
  #         |> Flash.insert_flash(:info, "Transition already approved!", self())
  #       }
  #   end
  # end
end
