defmodule LifecycleWeb.PartyLive.Index do
  @moduledoc false

  use LifecycleWeb, :live_view

  alias Lifecycle.Timezone

  alias Lifecycle.Massline

  @impl true
  def mount(_params, _session, socket) do
    socket = Timezone.get_timezone(socket)
    timezone = socket.assigns.timezone
    timezone_offset = socket.assigns.timezone_offset
    IO.inspect(socket.assigns.timezone)

    {:ok, assign(socket,
      all_party: list_party()
    )}

  end

  defp list_party do
    Massline.list_parties()
  end

end
