defmodule LifecycleWeb.JourneyLive.Index do
  use LifecycleWeb, :live_view
  use Timex

  alias Lifecycle.Timezone

  alias Lifecycle.Pubsub

  alias Lifecycle.Timeline
  alias Lifecycle.Timeline.Journey

  @topic inspect(__MODULE__)

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Pubsub.subscribe("1") #topic TODO change the topic
    socket = Timezone.getTimezone(socket)
    timezone = socket.assigns.timezone
    timezone_offset = socket.assigns.timezone_offset
    changeset = Timeline.Journey.changeset(%Journey{})
    {:ok, assign(socket, journeys: list_journeys(), timezone: timezone, changeset: changeset, timezone_offset: timezone_offset, new_journey: [])}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Journey")
    |> assign(:journey, %Journey{})
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Journey")
    |> assign(:journey, Timeline.get_journey!(id))
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Journey")
    |> assign(:journey, nil)
  end

  def handle_event("save", %{"journey" => journey_params}, socket) do
    # save_echo(socket, :new, echo_params)
    case Timeline.create_journey(journey_params) do
      {:ok, journey} ->
        {Pubsub.notify_subs({:ok, journey}, [:journey, :created], "1")}
     {:noreply,
         socket
         |> put_flash(:info, "Journey created")
        #  |> Pubsub.notify_subs([:echo, :created], "1")
         # pub sub to be added
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def handle_info({Pubsub, [:journey, :created], _journey}, socket) do

    {:noreply, assign(socket, :new_journey, [_journey | socket.assigns.new_journey])}
  end

  defp list_journeys do
    Timeline.list_journeys()
  end

  def timeFormat(time, timezone, timezone_offset) do
    time
    |> Timezone.getTime(timezone, timezone_offset)
  end
end
