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
        %{
          transitions: transitions,
          id: id,
          timezone: timezone,
          timezone_offset: timezone_offset,
          phase: phase
        },
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
          <div class="w-96 mx-auto" style="scroll-snap-type: x mandatory;">
            <div class="text-center mt-6 mb-6 mx-auto font-light text-sm">
            <div class="max-w-2xl mx-auto">

                <%= for transition <- @transitions do %>
                    <!-- Card component -->
                    <div class="shadow-md rounded-md p-10 mx-1 my-3 bg-white text-left">
                      <h1 class="text-xl font-bold uppercase">
                        <%= live_redirect transition.phase.title , to: Routes.phase_show_path(@socket, :show, transition.phase), class: "button" %>
                      </h1>
                      <h2 class="text-sm font-semibold uppercase mt-5 underline">
                        Observations
                      </h2>
                      <div class="flex flex-wrap">
                        <%= for {property, value} <- transition.answers do %>
                          <%= if (property == "image_list") do %>
                            <!-- TODO: insert images here -->
                            <%= unless value == "" do %>
                              <div class="shadow-md rounded-md">
                                <div class="container px-5 py-2 mx-auto">
                                  <div class="flex flex-wrap -m-1 md:-m-2 items-center justify-center">
                                    <%= for image_path <- String.split(value, "##" ) do%>
                                      <div class="flex flex-wrap w-1/3">
                                        <button class="w-full p-1 md:p-2">
                                          <img alt="gallery" class="button block object-cover object-center w-full h-full rounded-lg"
                                            src={image_path}>
                                        </button>
                                      </div>
                                    <% end %>
                                  </div>
                                </div>
                              </div>
                            <% end %>
                          <% end %>
                        <% end %>


                        <!-- Traits component -->
                        <%= for {property, value} <- transition.answers do %>
                          <!-- bool & text Traits -->
                          <%= if (property == "bool" || property == "text") do %>
                            <%= for {key, val} <- value do %>
                              <div class="shadow-md rounded-md bg-stone-100 m-1">
                                <div class="p-3 text-center">
                                  <h3><%= key %><br></h3>
                                </div>
                                <h2 class="text-xl font-medium">
                                  <%= Map.values(val) %>
                                </h2>
                              </div>
                            <% end %>
                          <% end %>
                          <!-- numeric Traits -->
                          <%= if (property == "numeric") do %>
                            <%= for {trait_name, trait_dict} <- value do %>
                              <div class="shadow-md rounded-md bg-stone-200 m-1">
                                <div class="p-3 text-center">
                                  <h3><%= trait_name %><br></h3>
                                  <div class="w-10">
                                    <h2 class="text-xl font-medium">
                                      <%=
                                        [_, trait_value]=Map.values(trait_dict)
                                        trait_value
                                      %>
                                    </h2>
                                    <h2 class="text-m font-small">
                                      <%=
                                        [trait_unit, _]=Map.values(trait_dict)
                                        trait_unit
                                      %>
                                    </h2>
                                  </div>
                                </div>
                              </div>
                            <% end %>
                          <% end %>
                        <% end %>

                        <%= for {property, value} <- transition.answers do %>
                        <!-- Comment component -->
                          <%= if (property == "comment" ) do %>
                            <div class="shadow-md rounded-md bg-stone-300 m-1">
                              <div class="p-5 text-center">
                                <h3>Comments<br></h3>
                              <h2 class="text-xl font-medium">
                                <%= Map.values(value) %>
                              </h2>
                              </div>
                            </div>
                          <% end %>
                        <% end %>

                      </div>



                      <br>
                      <h2 class="text-sm font-semibold"><%= transition.initiator.name %></h2>
                      <h2 class="text-xs font-semibold"><%= if @id == "transition" do %> <%= Timezone.get_date(transition.inserted_at, assigns.timezone, assigns.timezone_offset) %> <% end %>  <%= Timezone.get_time(transition.inserted_at, assigns.timezone, assigns.timezone_offset) %><br></h2>
                      <br>
                      <div class="flex items-center justify-center">
                      Transited: <%= transition.transited %><br>
                      <%= if transition.transited do %>
                          Approved by: <%= transition.transiter.name %><br>
                      <% else %>
                          <button phx-click="transit", value={transition.id}, class="button px-4 py-1 text-lg bg-orange-300 text-white font-light rounded-full hover:text-white hover:bg-orange-600 hover:font-semibold m-1">Approve</button>
                      <% end %>
                        <%= live_patch "Edit", to: Routes.phase_show_path(@socket, :transition_edit, transition.phase_id, transition.id), class: "button px-4 py-1 text-lg bg-orange-300 text-white font-light rounded-full hover:text-white hover:bg-orange-600 hover:font-semibold m-2" %>
                        <%= link "Delete", to: "#", phx_click: "delete-transition", phx_value_id: transition.id, data: [confirm: "Are you sure?"], class: "button px-4 py-1 text-lg bg-red-300 text-white font-light rounded-full hover:text-white hover:bg-red-600 hover:font-semibold m-2" %>
                      </div>


                    </div>
            <% end %>
            </div>
            <script src="https://unpkg.com/flowbite@1.4.1/dist/flowbite.js"></script>
            </div>
          </div>

    """
  end
end
