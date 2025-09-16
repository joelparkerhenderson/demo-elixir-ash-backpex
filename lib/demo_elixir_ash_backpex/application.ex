defmodule DemoElixirAshBackpex.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      DemoElixirAshBackpexWeb.Telemetry,
      DemoElixirAshBackpex.Repo,
      {DNSCluster,
       query: Application.get_env(:demo_elixir_ash_backpex, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: DemoElixirAshBackpex.PubSub},
      # Start a worker by calling: DemoElixirAshBackpex.Worker.start_link(arg)
      # {DemoElixirAshBackpex.Worker, arg},
      # Start to serve requests, typically the last entry
      DemoElixirAshBackpexWeb.Endpoint,
      {AshAuthentication.Supervisor, [otp_app: :demo_elixir_ash_backpex]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: DemoElixirAshBackpex.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    DemoElixirAshBackpexWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
