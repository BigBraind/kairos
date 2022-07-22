defmodule LifecycleWeb.Components.AdminSidebar do
  use LifecycleWeb, :live_component

  @impl true
  def mount(socket), do: {:ok, socket}

  @impl true
  def render(assigns) do
    ~H"""
    <li class="items-center" phx-click="on-click" phx-target={@myself}>
      <%= live_patch(to: @to, class: "text-xs uppercase py-3 font-bold block text-gray-500 hover:text-blue-400", phx: [click: "click", value: "value"]) do %>
        <i class={"fas mr-2 text-sm opacity-75 #{@icon}"}></i>
        <%= @title %>
      <% end %>
    </li>
    """
  end
end
