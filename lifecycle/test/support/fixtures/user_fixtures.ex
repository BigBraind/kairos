defmodule Lifecycle.UserFixtures do
  @moduledoc """
  This module defines test helpers for creating users
  """
  alias Lifecycle.Repo
  alias Pow.Plug.Session

  def set_user_session(conn, user) do
    opts = Session.init(otp_app: :lifecycle)

    %Plug.Conn{conn | secret_key_base: LifecycleWeb.Endpoint.config(:secret_key_base)}
    |> Pow.Plug.put_config(otp_app: :lifecycle)
    |> Plug.Test.init_test_session(%{})
    |> Session.call(opts)
    |> Session.do_create(user, opts)
  end

  def user_fixtures(_attr \\ %{}) do
    user = %Lifecycle.Users.User{name: "Bruce Lee", id: Ecto.UUID.generate()}
    Repo.insert(user)
  end

end
