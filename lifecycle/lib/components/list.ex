defmodule LifecycleWeb.Components.List do
  use LifecycleWeb, :live_component

  @impl true
  def mount(socket), do: {:ok, socket}

  @impl true
  def update(%{editable: true} = assigns, socket) do
    {:ok, socket
    |> assign(class: Map.get(assigns, :class, view_class()))
    |> assign(disabled: Map.get(assigns, :disabled, true))
    |> assign(assigns)}
  end

  @impl true
  def update(assigns, socket), do: {:ok, assign(socket, assigns)}

  @impl true
  def render(assigns) do
    if (Map.get(assigns, :value) != nil) do
      ~H"""
      <div class="w-full flex items-center justify-between px-4 py-2 border-b">
        <div class="w-1/2"><%= @name %></div>
        <div class="w-1/2"><%= if(Map.get(assigns, :editable, false), do: (assigns), else: @value) %></div>
      </div>
      """
    else
      ~H"""
      <div class="w-full flex items-center justify-between px-4 py-2 border-b">
        <div class="w-1/2"><%= @name %></div>
        <div class="w-1/2">
          <%= render_slot(@inner_block) %>
        </div>
      </div>
      """
    end
  end

  @impl true
  def handle_event("edit_value", _params, %{assigns: assigns} = socket) do
    case Map.get(assigns, :disabled) do
      true -> {:noreply, assign(socket, [class: edit_class(), disabled: false])}
      _ -> {:noreply, assign(socket, [class: view_class(), disabled: true])}
    end
  end

  @impl true
  def handle_event("update", params, %{assigns: %{update: update, data: data}} = socket) when is_function(update) do
    socket = assign(socket, :disabled, true)
    case apply(update, [data, params]) do
      true -> {:noreply, put_flash(socket, :info, "data updated successfully")}
      {:ok, msg} when is_bitstring(msg) -> {:noreply, put_flash(socket, :info, msg)}
      {:ok, data} when is_map(data) -> {:noreply, put_flash(socket, :info, "data updated successfully") |> assign(:data, data)}
      {:error, msg} -> {:noreply, put_flash(socket, :error, msg)}
      _ -> {:noreply, put_flash(socket, :error, "data failed to update")}
    end
  end

  def editable_value(%{value: value, class: class, data: data} = assigns) do
    changeset = Ecto.Changeset.change(data)

    ~H"""
    <.form let={f} for={changeset} phx-submit="update" class="flex w-full items-center" phx-target={@myself}>
      <%= text_input f, :value, value: Map.get(data, value), class: @class, disabled: @disabled, focus: true %>
      <span phx-click="edit_value" phx-target={@myself} class={icon_class(@disabled)}>
        <i class="fa-solid fa-pencil cursor-pointer"></i>
      </span>
      <%= submit "update", class: submit_class(@disabled) %>
    </.form>
    """
  end

  defp icon_class(true = _disabled), do: "h-4 w-4 ml-2 flex"
  defp icon_class(_disabled), do: "hidden"

  defp submit_class(true = _disabled), do: "hidden"
  defp submit_class(_disabled), do: "ml-2 button-sm"

  defp view_class do
    "border rounded p-2 disabled cursor-not-allowed overflow-none w-full md:w-1/2 lg:w-1/3"
  end

  defp edit_class do
    "border rounded p-2 overflow-none w-full md:w-1/2 lg:w-1/3"
  end
end
