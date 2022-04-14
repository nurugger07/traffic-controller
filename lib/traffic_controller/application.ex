defmodule TrafficController.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      TrafficController.LightController,
      TrafficController.ShortTimer,
      TrafficController.LongTimer,
      TrafficController.VehicleDetection
    ]

    opts = [strategy: :one_for_one, name: TrafficController.Supervisor]
    Supervisor.start_link(children, opts)
  end
end




