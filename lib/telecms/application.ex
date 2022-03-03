defmodule Telecms.Application do
  use Application

  @impl true
  def start(_type, _args) do
    tail = [
      # Start the Telemetry supervisor
      TelecmsWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Telecms.PubSub},
      # Start the Endpoint (http/https)
      TelecmsWeb.Endpoint
      # Start a worker by calling: Telecms.Worker.start_link(arg)
      # {Telecms.Worker, arg}
    ]

    opts = [strategy: :one_for_one, name: Telecms.Supervisor]

    children = Application.get_env(:telecms, :children) ++ tail

    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TelecmsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
