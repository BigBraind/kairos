defmodule LifecycleWeb.Modal.View.Transition.PhaseTransition do
    use Phoenix.Component

    alias Lifecycle.Timezone

    def button(assigns) do
      ~H"""
        <%= for transition <- assigns.transitions do %>
            id: <%= transition.id %> <br> this line to be removed, user dont need to see <br>
            creator: <%= transition.initiator.name %><br>
            transited: <%= transition.transited %><br>

            <%= if transition.transited do %>
                Approved by: <%= transition.transiter.name %><br>
            <% end %>
            inserted at: <%= Timezone.get_date(transition.inserted_at, assigns.timezone, assigns.timezone_offset) %><br>
            <button phx-click="transit", value={transition.id} > Approve?</button>
        <% end %>
      """
    end

end
