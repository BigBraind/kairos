defmodule LifecycleWeb.Modal.View.Echoes.EchoList do
  @moduledoc """
  View component for individual echoes object and transition. being invoke in nowstream(echo_live/index.ex, phase_live/show.ex) construction and rendering echoes(echo_live/index.ex, phase_live/show.ex)
  """
  use LifecycleWeb, :live_component

  use Timex
  alias Lifecycle.Timezone

  alias LifecycleWeb.Modal.View.Button.Approve

  @doc """
  Display transition object, including image/audio uploaded

  checking transition state,
    if true, display the button to approve,
    if false, display by who

    audio format <> String.slice(Path.extname(@echo.message), 1, 10)
  """
  def transition_list(assigns) do
    ~H"""
      <b> <%= @echo.user_name %> </b> : <br>
      <article class="column">
        <%= if Path.extname(@echo.message) in [".mp3", ".m4a" ,".aac", ".oga"] do %>
          <audio controls>
          <source src={@assets_path} type={"audio/mp4"} >
          </audio>
        <% else %>
          <img alt="assets image" src={@assets_path}>
        <% end %>
      </article>

      <i style="float:right;color: gray;"><%= Timezone.get_time(@echo.inserted_at, @timezone, @timezone_offset) %><br></i>
    """
  end

  @doc """
  Individual Echo object
  """
  def echo_list(assigns) do
    ~H"""
      <b><%= @echo.user_name %></b>: <%= @echo.message %> <i style="float:right;color: gray;"><%= Timezone.get_time(@echo.inserted_at, @timezone, @timezone_offset) %> </i><br>
    """
  end

end
