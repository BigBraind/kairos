defmodule LifecycleWeb.Modal.Button.Transition do
  @moduledoc """
  Transition button
  """
  use LifecycleWeb, :live_view

  alias Lifecycle.Pubsub
  alias Lifecycle.Timeline

  alias LifecycleWeb.Modal.Pubsub.Pubs

  def button(assigns) do
    ~H"""
      <button phx-click="transition">Drop Beats 🖐🎤</button>
    """
  end

  @doc """
  handle event for approve button
  assign transiting to true, such that users can upload image to be approved
  """
  def handle_button("transition", socket) do
    {:noreply,
     socket
     |> assign(:transiting, true)}
  end

  @doc """
    Construct the file path of the image uploaded, and save it to local file system
    Create transition echo object
  """
  def handle_upload("upload", socket) do
    # function to get the file path and save it to local file system
    uploaded_files =
      consume_uploaded_entries(socket, :transition, fn %{path: path}, entry ->
        ext = entry.client_name
        dest_path = path <> ext
        # changes destination path name with extension for rendering
        dest =
          Path.join([:code.priv_dir(:lifecycle), "static", "uploads", Path.basename(dest_path)])

        File.cp!(path, dest)
        {:ok, Routes.static_path(socket, "/uploads/#{Path.basename(dest)}")}
      end)

    # convert list to string
    image_list = Enum.join(uploaded_files, "##")

    # construct echo_params for creating transition echo objects
    echo_params = %{
      "message" => image_list,
      "type" => "transition",
      "name" => socket.assigns.current_user.name,
      "transited" => false,
      "phase_id" => socket.assigns.phase.id
    }

    topic = Pubs.get_topic(socket)

    case Timeline.create_echo(echo_params) do
      {:ok, echo} ->
        {Pubsub.notify_subs({:ok, echo}, [:echo, :created], topic)}

        {
          :noreply,
          socket
          |> assign(:transiting, false)
          |> put_flash(:info, "Transition Object Sent")
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
