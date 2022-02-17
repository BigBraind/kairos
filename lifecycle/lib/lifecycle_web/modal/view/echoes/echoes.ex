defmodule LifecycleWeb.Modal.View.Echoes.Echoes do
  @moduledoc """
  Live View Component for rendering Echoes
  It calls normal echoes(message) object and transition object(image/audio) from modal/echo_list.ex
  """
  use LifecycleWeb, :live_component
  use Timex

  alias LifecycleWeb.Modal.View.Echoes.EchoList

  def mount(socket) do
    {:ok, socket}
  end

  # the update function is invoked with all the assigns given to live_compoennt/1,
  # refer to the documentation for phoenix about the live_component life-cycle.
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
end
