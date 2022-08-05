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
              <div class="text-md text-pink-500 font-weight-light ">

                <%= Timex.format!(@current, "{Mshort} {YYYY}") %>
              </div>
              <div class="flex justify-end flex-1 text-right">
                <%= live_patch to: @previous_month_path do %>
                    <button class="mr-1 smaller-fab">
                    Past Month
                    </button>
                <% end %>
                <%= live_patch to: @next_month_path do %>
                    <button class="ml-1 smaller-fab">
                    Next Month
                    </button>
                <% end %>
              </div>
          </div>
          <div class=" text-xl uppercase calendar grid grid-cols-7 gap-y-2 gap-x-2 dark:text-white">
              <div class="">Mon</div>
              <div class="">Tue</div>
              <div class="">Wed</div>
              <div class="">Thu</div>
              <div class="">Fri</div>
              <div class="">Sat</div>
              <div class="">Sun</div>
              <%= for i <- 0..(@end_of_month.day - 1) do %>
                <Day.calendar
                  index={i}
                  current_path={@current_path}
                  date={Timex.shift(@beginning_of_month, days: i)}
                  timezone={@timezone} />
              <% end %>

            </div>
        </div>
    """
    # deleted the region thing 'Asia/Singapore'
    # <div class="flex items-center gap-x-1">
    # <%= @timezone %>
    # </div>
  end

  defp build_path(current_path, params) do
    current_path
    |> URI.parse()
    |> Map.put(:query, URI.encode_query(params))
    |> URI.to_string()
  end
end
