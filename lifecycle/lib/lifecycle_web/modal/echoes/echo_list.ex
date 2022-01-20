defmodule LifecycleWeb.Modal.Echoes.EchoList do
  @moduledoc """
  Function component for individual echoes object and transition. being invoke in nowstream(echo_live/index.ex, phase_live/show.ex) construction and rendering echoes(echo_live/index.ex, phase_live/show.ex)
  """
  use LifecycleWeb, :live_component

  use Timex
  alias Lifecycle.Timezone

  alias LifecycleWeb.Modal.Button.Approve

  @doc """
  Transition object

  checking transition state,
    if true, display the button to approve,
    if false, display by who
  """
  def transition_list(assigns) do
    ~H"""
      <b><%= @echo.name %></b>: <br>
      <article class="column">
        <img alt="product image" src= {@image_path}>
      </article>

      <i style="float:right;color: gray;"><%= time_format(@echo.inserted_at, @timezone, @timezone_offset) %><br></i>

      <%= if @echo.transited == false do %>
        <Approve.button echo={@echo}/>
        <br>
      <% else %>
        <b>Approved by <%= @echo.transiter %>!</b><br>
      <% end %>

    """
  end

  @doc """
  Individual Echo object
  """
  def echo_list(assigns) do
    ~H"""
      <b><%= @echo.name %></b>: <%= @echo.message %> <i style="float:right;color: gray;"><%= time_format(@echo.inserted_at, @timezone, @timezone_offset) %> </i><br>
    """
  end

  defp time_format(time, timezone, timezone_offset) do
    Timezone.get_time(time, timezone, timezone_offset)
  end


end
