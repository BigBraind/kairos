defmodule Lifecycle.Timezone do
  @moduledoc """
    The timezone module is to customize the time format that we want.
    Currently it's displayed as DD-MM-YYYY
  """
  use LifecycleWeb, :live_view

  # TODO: style the timezone into time: DD-MM-YYYY

  @default_locale "en"
  @default_timezone "UTC"
  @default_timezone_offset 0

  defp assign_locale(socket) do
    locale = get_connect_params(socket)["locale"] || @default_locale
    assign(socket, locale: locale)
  end

  defp assign_timezone(socket) do
    timezone = get_connect_params(socket)["timezone"] || @default_timezone
    assign(socket, timezone: timezone)
  end

  defp assign_timezone_offset(socket) do
    timezone_offset = get_connect_params(socket)["timezone_offset"] || @default_timezone_offset
    assign(socket, timezone_offset: timezone_offset)
  end

  def get_timezone(socket) do
    socket
    |> assign_locale()
    |> assign_timezone()
    |> assign_timezone_offset()
  end

  def get_time(time, timezone, timezone_offset) do
    time
    |> DateTime.from_naive!(timezone)
    |> Timex.shift(hours: timezone_offset)
    |> Timex.format("{YYYY}-{0M}-{D}")
    |> elem(1)
  end
end
