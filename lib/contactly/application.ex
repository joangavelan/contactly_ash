defmodule Contactly.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ContactlyWeb.Telemetry,
      Contactly.Repo,
      {DNSCluster, query: Application.get_env(:contactly, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Contactly.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Contactly.Finch},
      # Start a worker by calling: Contactly.Worker.start_link(arg)
      # {Contactly.Worker, arg},

      # Start the SSR process pool
      # You must specify a `path` option to locate the directory where the `ssr.js` file lives.
      {Inertia.SSR, path: Path.join([Application.app_dir(:contactly), "priv"])},

      # Start to serve requests, typically the last entry
      ContactlyWeb.Endpoint,
      {AshAuthentication.Supervisor, [otp_app: :contactly]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Contactly.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ContactlyWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
