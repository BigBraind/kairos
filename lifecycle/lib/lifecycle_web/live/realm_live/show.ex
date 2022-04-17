defmodule LifecycleWeb.RealmLive.Show do
  use LifecycleWeb, :live_view

  import ContexSampleWeb.Shared

  alias Contex.{LinePlot, PointPlot, Dataset, Plot}
  alias Lifecycle.Users

  @impl true
  def mount(%{"party_name" => party, "realm_name" => realm}, _session, socket) do
    socket =
      socket
      |> assign(chart_options: %{
          series: 3,
          points: 99999,
          title: nil,
          type: "line",
          smoothed: "yes",
          colour_scheme: "default",
          show_legend: "yes",
          custom_x_scale: "no",
          custom_y_scale: "no",
          custom_y_ticks: "no",
          time_series: "no"
          })
      |> assign(prev_series: 0, prev_points: 0, prev_time_series: nil)
      |> make_test_data()
    realm_topic = "realm:" <> party <> ":" <> realm
    if connected?(socket), do: Lifecycle.Pubsub.subscribe(realm_topic)
    {:ok,
     socket
     |> assign(:party_name, party)
     |> assign(:realm_topic, realm_topic)
     |> assign(:nowstream, [])
     |> assign(:nowstream_counter, 0)
    }
  end

  @impl true
  def handle_params(%{"realm_name" => name}, _, socket) do

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:realm, Users.get_realm_by_name!(name))}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:realm, Users.get_realm!(id))}
  end

  @impl true
  def handle_info({Lifecycle.Pubsub, [:echo, :flux], message}, socket) do
    series_cols = ["humidity","temperature","co2"]
    {:noreply,
     socket
     |> assign(:nowstream, socket.assigns.nowstream ++ [[socket.assigns.nowstream_counter | message]])
     |> assign(:nowstream_counter, socket.assigns.nowstream_counter + 1)
     |> assign(:test_data, Dataset.new(socket.assigns.nowstream ++ [[socket.assigns.nowstream_counter | message]], ["X" | series_cols]))
    }
  end

  defp page_title(:show), do: "Show Realm"
  defp page_title(:edit), do: "Edit Realm"

  def build_pointplot(dataset, chart_options) do
    y_tick_formatter = case chart_options.custom_y_ticks do
      "yes" -> &custom_axis_formatter/1
      _ -> nil
    end

    module = case chart_options.type do
      "line" -> LinePlot
      _ -> PointPlot
    end

    custom_x_scale = make_custom_x_scale(chart_options)
    custom_y_scale = make_custom_y_scale(chart_options)

    options = [
      mapping: %{x_col: "X", y_cols: chart_options.series_columns},
      colour_palette: lookup_colours(chart_options.colour_scheme),
      custom_x_scale: custom_x_scale,
      custom_y_scale: custom_y_scale,
      custom_y_formatter: y_tick_formatter,
      smoothed: (chart_options.smoothed == "yes")
    ]

    plot_options = case chart_options.show_legend do
      "yes" -> %{legend_setting: :legend_right}
      _ -> %{}
    end


    plot = Plot.new(dataset, module, 600, 400, options)
      |> Plot.titles(chart_options.title, nil)
      |> Plot.plot_options(plot_options)

    Plot.to_svg(plot)
  end

  defp make_test_data(socket) do
    options = socket.assigns.chart_options
    time_series = (options.time_series == "yes")
    prev_series = socket.assigns.prev_series
    prev_points = socket.assigns.prev_points
    prev_time_series = socket.assigns.prev_time_series
    series = options.series
    points = options.points

    needs_update = (prev_series != series) or (prev_points != points) or (prev_time_series != time_series)

    # first dummy data
    data = [
      [0,0,0,0,0]
    ]

    # TODO: add the lable for the data here
    series_cols = ["humidity","temperature","co2"]

    test_data = case needs_update do
      true ->  Dataset.new(data, ["X" | series_cols])
      _ -> socket.assigns.test_data
    end

    options = Map.put(options, :series_columns, series_cols)

    assign(socket,
      test_data: test_data,
      chart_options: options,
      prev_series: series,
      prev_points: points,
      prev_time_series: time_series
    )
  end

  def custom_axis_formatter(value) when is_float(value) do
    "V #{:erlang.float_to_binary(value/1_000.0, [decimals: 2])}K"
  end

  def custom_axis_formatter(value) do
    "V #{value}"
  end

  defp make_custom_x_scale(%{custom_x_scale: x}=_chart_options) when x != "yes", do: nil
  defp make_custom_x_scale(chart_options) do
    case (chart_options.time_series == "yes") do
      true ->
        Contex.TimeScale.new()

      _ ->
        Contex.ContinuousLinearScale.new()
        |> Contex.ContinuousLinearScale.domain(0, 100)
        |> Contex.ContinuousLinearScale.interval_count(20)

    end
  end

  defp make_custom_y_scale(%{custom_y_scale: x}=_chart_options) when x != "yes", do: nil
  defp make_custom_y_scale(_chart_options) do
    Contex.ContinuousLinearScale.new()
    |> Contex.ContinuousLinearScale.domain(0, 100)
    |> Contex.ContinuousLinearScale.interval_count(20)
  end

end
