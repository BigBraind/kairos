defmodule LifecycleWeb.Modal.View.Calendar.Month do
  @moduledoc """
  View component for displaying month and headers for days
  """
  use Phoenix.Component

  alias LifecycleWeb.Modal.View.Calendar.Day

  def calendar(
        %{
          current_path: current_path,
          previous_month: previous_month,
          next_month: next_month
        } = assigns
      ) do
    previous_month_path = build_path(current_path, %{month: previous_month})
    next_month_path = build_path(current_path, %{month: next_month})

    assigns =
      assigns
      |> assign(previous_month_path: previous_month_path)
      |> assign(next_month_path: next_month_path)

    ~H"""
        <div>
          <div class="flex items-center mb-8">
              <div class="flex-1">
                <%= Timex.format!(@current, "{Mshort} {YYYY}") %>
              </div>
              <div class="flex justify-end flex-1 text-right">
                <%= live_patch to: @previous_month_path do %>
                    <button class="flex items-center justify-center w-10 h-10 text-blue-700 align-middle rounded-full hover:bg-blue-200">
                    <i class="fas fa-chevron-left"> Previous        </i>
                    </button>
                <% end %>
                <%= live_patch to: @next_month_path do %>
                    <button class="flex items-center justify-center w-10 h-10 text-blue-700 align-middle rounded-full hover:bg-blue-200">
                    <i class="fas fa-chevron-right"> Next </i>
                    </button>
                <% end %>
              </div>
          </div>
          <div class="mb-6 text-center uppercase calendar grid grid-cols-7 gap-y-2 gap-x-2">
              <div class="text-xs">Mon</div>
              <div class="text-xs">Tue</div>
              <div class="text-xs">Wed</div>
              <div class="text-xs">Thu</div>
              <div class="text-xs">Fri</div>
              <div class="text-xs">Sat</div>
              <div class="text-xs">Sun</div>
              <%= for i <- 0..(@end_of_month.day - 1) do %>
                <Day.calendar
                  index={i}
                  current_path={@current_path}
                  date={Timex.shift(@beginning_of_month, days: i)}
                  timezone={@timezone} />
              <% end %>
              <div class="flex items-center gap-x-1">
                  <i class="fas fa-globe-americas"></i>
                  <%= @timezone %>
              </div>
            </div>
        </div>
    """
  end

  defp build_path(current_path, params) do
    current_path
    |> URI.parse()
    |> Map.put(:query, URI.encode_query(params))
    |> URI.to_string()
  end
end
