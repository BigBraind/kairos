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

  # max-w-md max-h-md

  def render(assigns) do
    ~H"""
        <div class="text-center mt-6 mb-6 mx-auto font-light text-sm">
            <%= for transition <- @transitions do %>
                from : <%= transition.phase.title %> <br>
                <%= for {property, value} <- transition.answers do %>
                  <%= unless property == "image_list" do %>
                      <%= property%> : <%= value %> <br>
                  <% else %>
                      <%= unless value == "" do %>
                          <%= for image_path <- String.split(value, "##" ) do%>

                            <%= if Path.extname(image_path) in [".mp3", ".m4a" ,".aac", ".oga"] do %>
                              <audio controls>
                              <source src={image_path} type={"audio/mp4"} >
                              </audio>
                            <% else %>
                              <img class="text-center mt-6 mb-6 mx-auto object-contain h-48 w-96 font-light text-sm" alt="assets image" src={image_path}>
                            <% end %>

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

                <%= if @id == "transition" do %>
                  <span><%= live_patch "Edit Transition", to: Routes.phase_show_path(@socket, :transition_edit, transition.phase_id, transition.id), class: "button" %></span>
                <% else %>
                  <span><%= live_patch "Edit Transition", to: Routes.transition_index_path(@socket, :index), class: "button" %></span>
                <% end %>

                <br>

                <span class = "px-4 py-1 text-lg bg-red-200 text-white font-light rounded-full hover:text-white hover:bg-red-600 hover:font-semibold"><%= link "Delete", to: "#", phx_click: "delete-transition", phx_value_id: transition.id, data: [confirm: "Are you sure?"], class: "button" %></span>
                <br>
                <br>
            <% end %>
        </div>
    """
  end
end
