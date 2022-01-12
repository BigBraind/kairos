defmodule LifecycleWeb.Modal.EchoList do
  use LifecycleWeb, :live_component

  use Timex
  alias Lifecycle.Timezone

  alias LifecycleWeb.Modal.Button.Approve

  def transition_list(assigns) do
    ~H"""
      <b><%= @echo.name %></b>: <br>
      <article class="column">
        <img alt="product image" src= {@image_path}>
      </article>

      <i style="float:right;color: gray;"><%= time_format(@echo.inserted_at, @timezone, @timezone_offset) %><br></i>

      <%= if @echo.transited == false do %>
        <!-- <button phx-click="approve" value={@echo.id}>Approve?</button> -->
        <Approve.button echo={@echo}/>
        <br>
      <% else %>
        <b>Approved by <%= @echo.transiter %>!</b><br>
      <% end %>

    """
  end

  def echo_list(assigns) do
    ~H"""
      <b><%= @echo.name %></b>: <%= @echo.message %> <i style="float:right;color: gray;"><%= time_format(@echo.inserted_at, @timezone, @timezone_offset) %> </i><br>
    """
  end

  def time_format(time, timezone, timezone_offset) do
    time
    |> Timezone.get_time(timezone, timezone_offset)
  end

end
