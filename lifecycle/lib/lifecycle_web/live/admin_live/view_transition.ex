defmodule LifecycleWeb.AdminLive.ViewTransition do
  @moduledoc false
  use LifecycleWeb, :live_view

  alias Lifecycle.Timeline
  alias LifecycleWeb.Modal.View.Transition.TransitionList

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       transition_list: Timeline.list_transitions()
     )}
  end
end
