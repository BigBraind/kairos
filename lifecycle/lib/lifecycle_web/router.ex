defmodule LifecycleWeb.Router do
  use LifecycleWeb, :router
  use Pow.Phoenix.Router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, {LifecycleWeb.LayoutView, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(Pow.Plug.Session, otp_app: :lifecycle)
  end

  pipeline :authenticated do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: Pow.Phoenix.PlugErrorHandler
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/" do
    pipe_through(:browser)

    pow_routes()
  end

  scope "/", LifecycleWeb do
    # pipe_through [:protected, :browser]
    pipe_through([:browser, :authenticated])

    get("/", PageController, :index)

    live_session :default, on_mount: {LifecycleWeb.Auth.Protocol, :auth} do
      live("/echoes", EchoLive.Index, :index)
      live("/echoes/new", EchoLive.Index, :new)
      live("/echoes/:id", EchoLive.Show, :show)

      live("/phases", PhaseLive.Index, :index)
      live("/phases/new", PhaseLive.Index, :new)
      live("/phases/:id/edit", PhaseLive.Index, :edit)

      live("/phases/:id", PhaseLive.Show, :show)
      live("/phases/:id/show/edit", PhaseLive.Show, :edit)
      live("/phases/:id/show/new", PhaseLive.Show, :new_child)
      live("/phases/:id/show/transition", PhaseLive.Show, :transition_new)
      live("/phases/:id/show/transition/:transition_id/edit", PhaseLive.Show, :transition_edit)

      live("/party", PartyLive.Index, :index)
      live("/party/new", PartyLive.Index, :new)
      live("/party/:party_name/edit", PartyLive.Index, :edit)

      live("/party/:party_name/show/edit", PartyLive.Show, :edit)
      live("/party/:party_name/", PartyLive.Show, :show)

      live("/billing", BillingLive.Index, :index)

      live("/transition", TransitionLive.Index, :index)
    end
  end

  # # Other scopes may use custom stacks.
  # scope "/api", LifecycleWeb do
  #   pipe_through :api

  #   live "/phases/:id", PhaseLive.Show, :show

  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through(:browser)
      live_dashboard("/dashboard", metrics: LifecycleWeb.Telemetry)
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through(:browser)

      forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end
  end
end
