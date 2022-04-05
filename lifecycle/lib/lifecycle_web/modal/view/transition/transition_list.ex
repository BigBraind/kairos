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

  defp format_string(string) do
    string
    |> String.trim_leading()
    |> String.trim_trailing()
    |> String.split("\n")
  end

  # max-w-md max-h-md

  def render(assigns) do
    ~H"""
          <div class="w-96 mx-auto" style="scroll-snap-type: x mandatory;">
            <div class="text-center mt-6 mb-6 mx-auto font-light text-sm">
            <div class="max-w-2xl mx-auto">

                <%= for transition <- @transitions do %>



                  <!--- first --->

                    <u>Source</u> : <%= live_redirect transition.phase.title , to: Routes.phase_show_path(@socket, :show, transition.phase), class: "button" %> <br>
                    <u>Creator:</u> <%= transition.initiator.name %><br>
                    <u>Created At:</u> <%= if @id == "transition" do %> <%= Timezone.get_date(transition.inserted_at, assigns.timezone, assigns.timezone_offset) %> <% end %>  <%= Timezone.get_time(transition.inserted_at, assigns.timezone, assigns.timezone_offset) %><br>
                    <%= for {property, value} <- transition.answers do %>
                      <%= unless property == "image_list" do %>
                          <%= property%> : <%= value %> <br>
                      <% else %>
                          <%= unless value == "" do %>
                              <div id="default-carousel" class="relative" data-carousel="static">
                                <div class="overflow-hidden relative h-56 rounded-lg sm:h-64 xl:h-80 2xl:h-96">
                              <%= for image_path <- String.split(value, "##" ) do%>

                                <%= if Path.extname(image_path) in [".mp3", ".m4a" ,".aac", ".oga"] do %>
                                  <audio controls>
                                  <source src={image_path} type={"audio/mp4"} >
                                  </audio>
                                <% else %>
                                <div class="active duration-700 ease-in-out" data-carousel-item>
                                    <img src={image_path} class="block absolute top-1/2 left-1/2 w-full -translate-y-1/2 -translate-x-1/2 transition" alt="...">
                                </div>
                                <% end %>
                                <% end %>
                                </div>
                                <div class="flex absolute bottom-5 left-1/2 z-30 space-x-3 -translate-x-1/2">
                                    <button type="button" class="w-3 h-3 rounded-full" aria-current="false" aria-label="Slide 1" data-carousel-slide-to="0"></button>
                                    <button type="button" class="w-3 h-3 rounded-full" aria-current="false" aria-label="Slide 2" data-carousel-slide-to="1"></button>
                                </div>
                                <!-- Slider controls -->
                                <button type="button" class="flex absolute top-0 left-0 z-30 justify-center items-center px-4 h-full cursor-pointer group focus:outline-none" data-carousel-prev>
                                    <span class="inline-flex justify-center items-center w-8 h-8 rounded-full sm:w-10 sm:h-10 bg-white/30 dark:bg-gray-800/30 group-hover:bg-white/50 dark:group-hover:bg-gray-800/60 group-focus:ring-4 group-focus:ring-white dark:group-focus:ring-gray-800/70 group-focus:outline-none">
                                        <svg class="w-5 h-5 text-white sm:w-6 sm:h-6 dark:text-gray-800" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path></svg>
                                        <span class="hidden">Previous</span>
                                    </span>
                                </button>
                                <button type="button" class="flex absolute top-0 right-0 z-30 justify-center items-center px-4 h-full cursor-pointer group focus:outline-none" data-carousel-next>
                                    <span class="inline-flex justify-center items-center w-8 h-8 rounded-full sm:w-10 sm:h-10 bg-white/30 dark:bg-gray-800/30 group-hover:bg-white/50 dark:group-hover:bg-gray-800/60 group-focus:ring-4 group-focus:ring-white dark:group-focus:ring-gray-800/70 group-focus:outline-none">
                                        <svg class="w-5 h-5 text-white sm:w-6 sm:h-6 dark:text-gray-800" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path></svg>
                                        <span class="hidden">Next</span>
                                    </span>
                                </button>
                              </div>
                          <% end %>
                      <% end %>
                    <% end %>
                    transited: <%= transition.transited %><br>
                    <%= if transition.transited do %>
                        Approved by: <%= transition.transiter.name %><br>
                    <% else %>
                        <button phx-click="transit", value={transition.id}>Approve?</button><br>
                    <% end %>
                    <div class="flex items-center justify-center">

                    <%= if @id == "transition" do %>
                      <span class="px-4 py-1 text-lg bg-orange-300 text-white font-light rounded-full hover:text-white hover:bg-orange-600 hover:font-semibold"><%= live_patch "Edit", to: Routes.phase_show_path(@socket, :transition_edit, transition.phase_id, transition.id), class: "button" %></span>
                    <% else %>
                      <span class="px-4 py-1 text-lg bg-orange-300 text-white font-light rounded-full hover:text-white hover:bg-orange-600 hover:font-semibold"><%= live_patch "Edit", to: Routes.transition_index_path(@socket, :index)%></span>
                    <% end %>

                    <br>
                    <span class = "px-4 py-1 text-lg bg-red-300 text-white font-light rounded-full hover:text-white hover:bg-red-600 hover:font-semibold"><%= link "Delete", to: "#", phx_click: "delete-transition", phx_value_id: transition.id, data: [confirm: "Are you sure?"], class: "button" %></span>
                    </div>
                    <br>
                    <br>
                    <hr class="border-0 bg-gray-500 text-gray-500 h-px w-full mb-8">
            <% end %>
            </div>
            <script src="https://unpkg.com/flowbite@1.4.1/dist/flowbite.js"></script>
          </div>
          </div>

    """
  end
end
