defmodule LifecycleWeb.Auth.Helpers do
  @moduledoc """
  Provides the helper functions for LifecycleWeb.Auth.Protocol
  """
  import Phoenix.LiveView

  alias Pow.Store.CredentialsCache
  alias Pow.Store.Backend.EtsCache

  @doc """
  Fetches current user details from session, if present
  """
  def assign_defaults(socket, session) do
    assign_new(socket, :current_user, fn -> get_user(socket, session) end)
  end

  defp get_user(socket, session, config \\ [otp_app: :lifecycle])

  defp get_user(socket, %{"lifecycle_auth" => signed_token}, config) do
    conn = struct!(Plug.Conn, secret_key_base: socket.endpoint.config(:secret_key_base))
    salt = Atom.to_string(Pow.Plug.Session)

    with {:ok, token} <- Pow.Plug.verify_token(conn, salt, signed_token, config),
         {user, _metadata} <- CredentialsCache.get([backend: EtsCache], token) do
      user
    else
      _ -> nil
    end
  end

  defp get_user(_, _, _), do: nil
end
