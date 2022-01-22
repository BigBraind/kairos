defmodule LifecycleWeb.Modal.Button.Phases do
  use LifecycleWeb, :live_component

  def mount(socket) do
    {:ok, socket}
  end

  def update(%{phase: phase}, socket) do
    {:ok,
     assign(socket,
       phase: phase
     )}
  end

  def render(assigns) do
    ~H"""
      <div>
        <%= if @phase.parent !== [] do %>
          <b>Parent: </b>

          <%= for parent <- @phase.parent do %>
            <span><%= live_redirect parent.title, to: Routes.phase_show_path(@socket, :show, parent), class: "button"%></span>
          <% end %>
        <% end %>

        <br>

        <%= if @phase.child !== [] do %>
          <b>Children: </b>
          <%= for child <- @phase.child do %>
            <span><%= live_redirect child.title, to: Routes.phase_show_path(@socket, :show, child), class: "button"%></span>
          <% end %>
        <% end %>
      </div>
    """
  end
end
