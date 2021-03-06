defmodule LifecycleWeb.Modal.Function.Transition.TransitionHandler do
  @moduledoc """
  Handle transition button event
  """

  use LifecycleWeb, :live_component

  alias Lifecycle.Pubsub
  alias Lifecycle.Timeline

  alias LifecycleWeb.Modal.Function.Component.Flash
  alias LifecycleWeb.Modal.Function.Pubsub.Pubs

  @doc """
  Approve transition event in phase show for transition object
  """
  def handle_transition(action, params, socket) do
    attrs =
      case action do
        :assign_transiter ->
          IO.inspect params
          %{}
          |> Map.put(:transiter_id, socket.assigns.current_user.id)
          |> Map.put(:transited, true)

        :edit_transition ->
          IO.puts "handle transition edit"
          IO.inspect params
          %{"answers" => params["answers"]}
      end

    transition = Timeline.get_transition_by_id(params["transition"])

    case Timeline.update_transition(transition, attrs) do
      {:ok, transition} ->
        case action do
          :edit_transition ->
            {{Pubsub.notify_subs(
                {:ok, transition},
                [:transition, :updated],
                "phase:" <> transition.phase_id
              )}}

          :assign_transiter ->
            {Pubsub.notify_subs(
               {:ok, transition},
               [:transition, :approved],
               "phase:" <> transition.phase_id
             )}
        end

        if action == :edit_transition do
          {:noreply,
           socket
           |> push_redirect(to: socket.assigns.return_to)}
        else
          {:noreply, socket}
        end

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply,
         socket
         |> assign(changeset: changeset)}
    end
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
      # !
      # FIXME: THE TYPE NOT LONGER NEEDED HERE
      "type" => "image",
      "poster_id" => socket.assigns.current_user.id,
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
          |> Flash.insert_flash(:info, "Transition Object Sent", self())
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  @doc """
  Handle delete transition event
  """
  def delete_transition(action, %{"id" => transition_id}, socket) do
    transition = Timeline.get_transition_by_id(transition_id)
    {:ok, deleted_transition} = Timeline.delete_transition(transition)

    {Pubsub.notify_subs(
       {:ok, deleted_transition},
       [:transition, :deleted],
       "phase:" <> deleted_transition.phase_id
     )}

    case action do
      :transition_view ->
        {:noreply,
         socket
         |> assign(
           :transitions,
           Timeline.get_transition_by_date(
             socket.assigns.current_date,
             socket.assigns.end_date
           )
         )}

      :phase_view ->
        {:noreply,
         socket
         |> assign(:transitions, Timeline.get_transition_list(socket.assigns.phase.id))}
    end
  end
end
