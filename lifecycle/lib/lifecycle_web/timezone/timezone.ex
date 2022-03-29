defmodule LifecycleWeb.Timezone.Timezone do
  @moduledoc """
  This adds the timezone into the socket for us to call easily from anywhere
  """

  use Phoenix.Component

  alias Lifecycle.Timezone

  @default_locale "en"
  @timezone "UTC"
  @timezone_offset 0

  def on_mount(:timezone, _params, _session, socket) do
    locale = get_connect_params(socket)["locale"] || @default_locale
    timezone = get_connect_params(socket)["timezone"] || @timezone
    timezone_offset = get_connect_params(socket)["timezone_offset"] || @timezone_offset

    {:cont,
     socket
     |> assign(:locale, locale)
     |> assign(:timezone, timezone)
     |> assign(:timezone_offset, timezone_offset)
     |> Timezone.get_current_end_date(timezone)} # get current date with time set to 00:00:00
  end
end
