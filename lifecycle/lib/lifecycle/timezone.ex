defmodule Lifecycle.Timezone do
  @moduledoc """
    The timezone module is to customize the time format that we want.
    Currently it's displayed as DD-MM-YYYY
  """
  use Phoenix.Component

  use Timex

  @doc """
  get_connect_params can only be called during mount, to avoid error, I purposely splitted out getting the date to query transition list here
  """
  def get_current_end_date(socket, timezone) do
    current_date =
      timezone
      |> Timex.today()
      |> Timex.to_naive_datetime()

    end_date =
      timezone
      |> Timex.today()
      |> Timex.shift(days: 1)
      |> Timex.to_naive_datetime()

    assign(socket, current_date: current_date, end_date: end_date)
  end

  @doc """
    Get the date in the format of YYYY-MM-DD
  """
  def get_date(time, timezone, timezone_offset) do
    time
    |> DateTime.from_naive!(timezone)
    |> Timex.shift(hours: timezone_offset)
    |> Timex.format("{D}-{0M}-{YYYY}")
    |> elem(1)
  end

  @doc """
    Get the time in the format of 12hrs, e.x.: 5:06pm
  """
  def get_time(time, timezone, timezone_offset) do
    time
    |> DateTime.from_naive!(timezone)
    |> Timex.shift(hours: timezone_offset)
    |> Timex.format("{h12}:{m} {am}")
    |> elem(1)
  end
end
