defmodule LifecycleWeb.Modal.Echoes.Echoes do
  use LifecycleWeb, :live_component

  alias LifecycleWeb.Modal.Echoes.EchoList

  use Timex

  def mount(socket) do
    {:ok, socket}
  end

  def update(%{echoes: echoes, id: id, timezone: timezone, timezone_offset: timezone_offset}, socket) do
    {:ok,
     assign(socket,
       id: id,
       echoes: echoes,
       timezone: timezone,
       timezone_offset: timezone_offset
     )}
  end

  def render(assigns) do
    ~H"""
      <ul phx-hook="SeparatingMsg" id="echoes-list" style="list-style-type:none;">
        <%= for echo <- @echoes do %>

          <li data-date={"#{echo.inserted_at}"} id={"echo-#{echo.id}"}>

            <%= if echo.type == "transition" do %>
              <EchoList.transition_list echo={echo}, timezone={@timezone} timezone_offset={@timezone_offset}, image_path={Routes.static_path(@socket, echo.message)}/>
            <% else %>
              <EchoList.echo_list echo={echo} timezone={@timezone} timezone_offset={@timezone_offset}/>
            <% end %>
          </li>
        <% end %>
      </ul>
    """
  end
end
