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

    audio format <> String.slice(Path.extname(@echo.message), 1, 10)
  """
  def transition_list(assigns) do
    ~H"""
      <b><%= @echo.name %></b>: <br>
      <article class="column">
        <%= if Path.extname(@echo.message) in [".mp3", ".m4a" ,".aac", ".oga"] do %>
          <audio controls>
          <source src={@assets_path} type={"audio/mp4"} >
          </audio>
        <% else %>
          <img alt="assets image" src={@assets_path}>
        <% end %>
      </article>

      <i style="float:right;color: gray;"><%= time_format(@echo.inserted_at, @timezone, @timezone_offset) %><br></i>

      <%= if @echo.transited == false do %>
        <Approve.button echo={@echo}/>
        <br>
      <% else %>
        <b style="color:#00A36C" >Reverberated by  <%= @echo.transiter %> 🌊🔉</b><br>
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
