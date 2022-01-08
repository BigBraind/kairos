defmodule Lifecycle.UserFixtures do
  @moduledoc """
  This module defines test helpers for creating users
  """
  alias Lifecycle.Repo

  def set_user_session(conn, user) do
    opts = Pow.Plug.Session.init(otp_app: :lifecycle)

    %Plug.Conn{conn | secret_key_base: LifecycleWeb.Endpoint.config(:secret_key_base)}
    |> Pow.Plug.put_config(otp_app: :lifecycle)
    |> Plug.Test.init_test_session(%{})
    |> Pow.Plug.Session.call(opts)
    |> Pow.Plug.Session.do_create(user, opts)
  end

  def user_fixtures(attr \\ %{}) do
    user = %Lifecycle.Users.User{name: "Bruce Lee", id: Ecto.UUID.generate()}
    Repo.insert(user)
  end

end
