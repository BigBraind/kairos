defmodule LifecycleWeb.Modal.Function.Calendar.CalendarHelpers do
    def class_list(items) do
        items
        |> Enum.reject(&(elem(&1, 1) == false))
        |> Enum.map(&elem(&1, 0))
        |> Enum.join(" ")
      end
end
