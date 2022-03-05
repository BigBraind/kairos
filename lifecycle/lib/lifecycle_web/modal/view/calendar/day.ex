defmodule LifecycleWeb.Modal.View.Calendar.Day do
  use Phoenix.Component
  use Timex

  alias __MODULE__

  alias LifecycleWeb.Modal.Function.Calendar.CalendarHelpers

  def calendar(
        %{index: index, current_path: current_path, date: date, timezone: timezone} = assigns
      ) do
    date_path = build_path(current_path, %{date: date})
    disabled = Timex.compare(date, Timex.today(timezone)) == -1
    weekday = Timex.weekday(date, :monday)

    class =
      CalendarHelpers.class_list([
        {"grid-column-#{weekday}", index == 0},
        {"content-center w-10 h-10 rounded-full justify-center items-center flex", true},
        {"bg-blue-50 text-blue-600 font-bold hover:bg-blue-200", true}
        # {"bg-blue-50 text-blue-600 font-bold hover:bg-blue-200", not disabled},
        # {"text-gray-200 cursor-default pointer-events-none", disabled}
        # {"text-gray-200 cursor-default pointer-events-none", false}
      ])

    assigns =
      assigns
      |> assign(disabled: disabled)
      |> assign(:text, Timex.format!(date, "{D}"))
      |> assign(:date_path, date_path)
      |> assign(:class, class)

    ~H"""
    <%= live_patch to: @date_path, class: @class, disabled: @disabled do %>
        <%= @text %>
    <% end %>
    """
    # <button class: {@class}> <%= @text %> </button>

  end

  defp build_path(current_path, params) do
    current_path
    |> URI.parse()
    |> Map.put(:query, URI.encode_query(params))
    |> URI.to_string()
  end
end
