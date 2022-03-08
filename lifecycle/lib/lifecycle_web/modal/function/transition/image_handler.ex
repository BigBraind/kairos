defmodule LifecycleWeb.Modal.Function.Transition.ImageHandler do
    @moduledoc """
        Handle image upload in when creating transition.
    """
    use LifecycleWeb, :live_component

    def handle_image(socket) do
        uploaded_files =
            consume_uploaded_entries(socket, :transition, fn %{path: path}, entry ->
              ext = String.replace(entry.client_name, " ", "")
              dest_path = path <> ext
              # changes destination path name with extension for rendering
              dest =
                Path.join([:code.priv_dir(:lifecycle), "static", "uploads", Path.basename(dest_path)])

              File.cp!(path, dest)

              {:ok, Routes.static_path(socket, "/uploads/#{Path.basename(dest)}")}
            end)

          # convert list to string
          image_list = Enum.join(uploaded_files, "##")
          image_list
    end

end
