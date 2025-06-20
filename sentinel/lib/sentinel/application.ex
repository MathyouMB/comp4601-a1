defmodule Sentinel.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Sentinel.Worker.start_link(arg)
      # {Sentinel.Worker, arg}
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: Sentinel.Router,
        options: [
          port: 4001
        ]
      )
    ]

    IO.inspect("Running on http://localhost:4001/")

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Sentinel.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
