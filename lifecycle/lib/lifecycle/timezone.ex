defmodule Lifecycle.Timezone do

  use LifecycleWeb, :live_view

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

  def getTimezone(socket) do
    socket
    |> assign_locale()
    |> assign_timezone()
    |> assign_timezone_offset()
  end

  def getTime(time, timezone, timezone_offset) do
    time
    |> DateTime.from_naive!(timezone)
    |> Timex.shift(hours: timezone_offset)
    |> Timex.format("{YYYY}-{0M}-{D}")
    |> elem(1)
  end
end
