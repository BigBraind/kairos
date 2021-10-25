defmodule LifecycleWeb.EchoLive.FormComponent do
  use LifecycleWeb, :live_component

  alias Lifecycle.Timeline

  @impl true
  def update(%{echo: echo} = assigns, socket) do
    changeset = Timeline.change_echo(echo)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"echo" => echo_params}, socket) do
    changeset =
      socket.assigns.echo
      |> Timeline.change_echo(echo_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"echo" => echo_params}, socket) do
    save_echo(socket, socket.assigns.action, echo_params)
  end

  defp save_echo(socket, :edit, echo_params) do
    case Timeline.update_echo(socket.assigns.echo, echo_params) do
      {:ok, _echo} ->
        {:noreply,
         socket
         |> put_flash(:info, "Echo updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_echo(socket, :new, echo_params) do
    IO.inspect echo_params
    case Timeline.create_echo(echo_params) do
      {:ok, _echo} ->
        {:noreply,
         socket
         |> put_flash(:info, "Echo created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def nowtime() do
    DateTime.utc_now
    |> to_string
 end
end
