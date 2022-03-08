defmodule LifecycleWeb.Modal.Function.Calendar.CalendarHelpers do
  @moduledoc """
  Helper function for Calendar view
  """

  @doc"""
  Check through the list if the CSS applies to the item
  """
  def class_list(items) do
    items
    |> Enum.reject(&(elem(&1, 1) == false))
    |> Enum.map_join(" ", &elem(&1, 0))
    # |> Enum.map(&elem(&1, 0))
    # |> Enum.join(" ")
  end
end
