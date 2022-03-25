defmodule LifecycleWeb.TransitionLive.Index do
  @moduledoc false

  use LifecycleWeb, :live_view
  use Timex

  alias Lifecycle.Timeline
  alias Lifecycle.Timezone

  alias LifecycleWeb.Modal.View.Calendar.Month
  alias LifecycleWeb.Modal.View.Transition.TransitionList

  alias LifecycleWeb.Modal.Function.Pubsub.TransitionPubs
  alias LifecycleWeb.Modal.Function.Transition.TransitionHandler

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> Timezone.get_current_end_date(socket.assigns.timezone)

    start_date = socket.assigns.current_date
    end_date = socket.assigns.end_date

    {:ok,
     socket
     |> assign(
       :transitions_by_date,
       Timeline.get_transition_by_date(
         start_date,
         end_date
       )
     )}
  end

  @impl true
  def handle_params(params, _url, socket) do
    socket =
      case Map.keys(params) do
        ["date"] ->
          date = params["date"]
          query_end_dates(date, socket)

        ["month"] ->
          socket

        [] ->
          socket
      end

    socket = assign_dates(socket, params)
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_event("transit", %{"value" => transition_id}, socket) do
    params = Map.put(%{}, "transition", transition_id)
    TransitionHandler.handle_transition(:assign_transiter, params, socket)
  end

  @impl true
  def handle_event("delete-transition", %{"id" => _transition_id} = params, socket) do
    TransitionHandler.delete_transition(:transition_view, params, socket)
    # transition = Timeline.get_transition_by_id(transition_id)
    # {:ok, deleted_transition} = Timeline.delete_transition(transition)

    # {Pubsub.notify_subs(
    #    {:ok, deleted_transition},
    #    [:transition, :deleted],
    #    "phase:" <> deleted_transition.phase_id
    #  )}

    # {:noreply,
    #  socket
    #  |> assign(:transitions, Timeline.get_transition_list(socket.assigns.phase.id))}
  end

  defp apply_action(socket, :index, _params) do
    if :start_date in Map.keys(socket.assigns) do
      assign(socket,
        transitions_by_date:
          Timeline.get_transition_by_date(
            socket.assigns.start_date,
            socket.assigns.end_date
          )
      )
    else
      socket
    end
  end

  defp query_end_dates(date, socket) do
    # start_date = NaiveDateTime.new!(Date.from_iso8601!(date), ~T[00:00:00])
    start_date =
      date
      |> Date.from_iso8601!()
      |> NaiveDateTime.new!(~T[00:00:00])
      |> Timex.shift(hours: socket.assigns.timezone_offset)

    end_date = Timex.shift(start_date, days: 1)

    assign(socket, start_date: start_date, end_date: end_date)
  end

  defp assign_dates(socket, params) do
    # current = Timex.today(socket.assigns.timezone)
    current = current_from_params(socket, params)

    beginning_of_month = Timex.beginning_of_month(current)
    end_of_month = Timex.end_of_month(current)

    previous_month =
      beginning_of_month
      |> Timex.add(Duration.from_days(-1))
      |> date_to_month()

    next_month =
      end_of_month
      |> Timex.add(Duration.from_days(1))
      |> date_to_month()

    socket
    |> assign(current: current)
    |> assign(beginning_of_month: beginning_of_month)
    |> assign(end_of_month: end_of_month)
    |> assign(previous_month: previous_month)
    |> assign(next_month: next_month)
  end

  defp date_to_month(date_time) do
    Timex.format!(date_time, "{YYYY}-{0M}")
  end

  @impl true
  def handle_info({Pubsub, [:transition, :approved], message}, socket) do
    TransitionPubs.handle_transition_updated(socket, message)
  end

  def handle_info({Pubsub, [:transition, :updated], message}, socket) do
    TransitionPubs.handle_transition_updated(socket, message)
  end

  def handle_info({Pubsub, [:transition, :created], message}, socket) do
    TransitionPubs.handle_transition_created(socket, message)
  end

  def handle_info({Pubsub, [:transition, :deleted], message}, socket) do
    TransitionPubs.handle_transition_deleted(socket, message)
  end

  defp current_from_params(socket, %{"month" => month}) do
    case Timex.parse("#{month}-01", "{YYYY}-{0M}-{D}") do
      {:ok, current} ->
        NaiveDateTime.to_date(current)

      _ ->
        Timex.today(socket.assigns.timezone)
    end
  end

  defp current_from_params(socket, _) do
    Timex.today(socket.assigns.timezone)
  end
end
