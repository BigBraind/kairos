defmodule LifecycleWeb.Modal.View.Transition.TransitionList do
  @moduledoc """
  View component for transition list
  """
  use LifecycleWeb, :live_component

  alias Lifecycle.Timezone

  def mount(socket) do
    {:ok, socket}
  end

  def update(
        %{transitions: transitions, id: id, timezone: timezone, timezone_offset: timezone_offset, phase: phase},
        socket
      ) do

    {:ok,
     assign(socket,
       id: id,
       phase: phase,
       transitions: transitions,
       timezone: timezone,
       timezone_offset: timezone_offset
     )}
  end

  def render(assigns) do
    ~H"""
        <div>
            <%= for transition <- @transitions do %>
                id: <%= transition.id %> <br>
                this line to be removed, user dont need to see <br>

                <%= for {property, value} <- transition.answers do %>
                  <%= unless property == "image_list" do %>
                      <%= property%> : <%= value %> <br>
                  <% else %>
                      <%= for image_path <- String.split(value, "##" ) do%>
                          <%= if Path.extname(image_path) in [".mp3", ".m4a" ,".aac", ".oga"] do %>
                            <audio controls>
                            <source src={image_path} type={"audio/mp4"} >
                            </audio>
                          <% else %>
                            <img alt="assets image" src={image_path}>
                          <% end %>
                          <% end %>
                  <% end %>
                <% end %>

                creator: <%= transition.initiator.name %><br>
                transited: <%= transition.transited %><br>

                created at: <%= Timezone.get_date(transition.inserted_at, assigns.timezone, assigns.timezone_offset) %> <%= Timezone.get_time(transition.inserted_at, assigns.timezone, assigns.timezone_offset) %><br>

                <%= if transition.transited do %>
                    Approved by: <%= transition.transiter.name %><br>
                <% else %>
                    <button phx-click="transit", value={transition.id}>Approve?</button><br>
                <% end %>


                <span><%= live_patch "Edit Transition", to: Routes.phase_show_path(@socket, :transition_edit, transition.phase_id, transition.id), class: "button" %></span>

                <br>

                <span><%= link "Delete", to: "#", phx_click: "delete-transition", phx_value_id: transition.id, data: [confirm: "Are you sure?"], class: "button" %></span>
                <br>
                <br>
            <% end %>
        </div>
    """
  end
end
