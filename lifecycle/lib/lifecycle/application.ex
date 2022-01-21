defmodule Lifecycle.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do

    topologies = Application.get_env(:libcluster, :topologies) || []

    children = [
      # Start the Ecto repository
      Lifecycle.Repo,
      # Start the Telemetry supervisor
      LifecycleWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Lifecycle.PubSub},
      # Start the Endpoint (http/https)
      LifecycleWeb.Endpoint,
      # Start a worker by calling: Lifecycle.Worker.start_link(arg)
      # {Lifecycle.Worker, arg}
      # setup for clustering
      {Cluster.Supervisor, [topologies, [name: Lifecycle.ClusterSupervisor]]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Lifecycle.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LifecycleWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
