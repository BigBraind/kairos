defmodule LifecycleWeb.TransLive.Index do
  use LifecycleWeb, :live_view

  alias Lifecycle.Pubsub
  alias Lifecycle.Timeline

  alias LifecycleWeb.Modal.View.Transition.TransitionList

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Pubsub.subscribe("new_trans")

    {:ok,
     assign(socket,
       changeset: %{},
       searching: false,
       search_result: nil
     )}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :view, _params) do
    socket
    # TODO: can be changed to fit the title of the page
    |> assign(:page_title, "Revamped Transitions")
    # TODO: to be filled up by the read transition query
    |> assign(:transitions, Timeline.get_transition_list("56ad2631-fbe8-40a3-a848-a28eb9b6de88"))
    # TODO: to be filled up by the read phase query
    |> assign(:phase, "56ad2631-fbe8-40a3-a848-a28eb9b6de88")
  end

  def handle_event("search", %{"search_field" => %{"query" => query}}, socket) do
    # TODO: to be replaced by actual search function
    search_result = "This is an intermediate result #{query}"

    {:noreply,
     assign(socket,
       searching: true,
       search_result: search_result
     )}
  end
end
