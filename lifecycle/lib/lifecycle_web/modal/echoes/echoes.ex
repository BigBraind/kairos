defmodule LifecycleWeb.Modal.Echoes.Echoes do
  @moduledoc """
  Live Component for rendeing Echoes
  It calls normal echoes(message) object and transition object from modal/echo_list.ex
  """
  use LifecycleWeb, :live_component

  alias Lifecycle.Timeline
  alias Lifecycle.Pubsub

  alias LifecycleWeb.Modal.Pubsub.Pubs
  alias LifecycleWeb.Modal.Echoes.EchoList

  use Timex

  def mount(socket) do
    {:ok, socket}
  end

  def update(
        %{echoes: echoes, id: id, timezone: timezone, timezone_offset: timezone_offset},
        socket
      ) do
    {:ok,
     assign(socket,
       id: id,
       echoes: echoes,
       timezone: timezone,
       timezone_offset: timezone_offset
     )}
  end

  def render(assigns) do
    # separating msg by date, done via phx-hook(JS interpolating)
    ~H"""
        <ul phx-hook={"#{if @id == "echoes", do: "SeparatingMsg"}"} id={"echoes-list-#{@id}"} style="list-style-type:none;">
        <%= for echo <- @echoes do %>

          <li data-date={"#{echo.inserted_at}"} id={"echo-#{echo.id}"}>

            <%= if echo.type == "transition" do %>
              <EchoList.transition_list echo={echo}, timezone={@timezone} timezone_offset={@timezone_offset}, assets_path={Routes.static_path(@socket, echo.message)}/>
            <% else %>
              <EchoList.echo_list echo={echo} timezone={@timezone} timezone_offset={@timezone_offset}/>
            <% end %>
          </li>
        <% end %>
        </ul>
    """
  end

  def send_echo(echo_params, socket) do
    topic = Pubs.get_topic(socket)

    case Timeline.create_echo(echo_params) do
      {:ok, echo} ->
        {Pubsub.notify_subs({:ok, echo}, [:echo, :created], topic)}

        {
          :noreply,
          socket
          |> put_flash(:info, "Message Sent")
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
