defmodule TrafficController.LongTimer do
  use GenServer

  alias TrafficController.LightController, as: Lights

  require Logger

  def start_link(_) do
    GenServer.start_link(__MODULE__, [running: false], name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end

  def start_timer do
    GenServer.cast(__MODULE__, :start_timer)
  end

  def handle_info(:reset_timer, _state) do
    Logger.info("Long Timer expired after 30 sec")

    Lights.transition()

    Process.send_after(self(), :reset_timer, 10_000)

    {:noreply, []}
  end

  def handle_cast(:start_timer, _state) do
    Process.send_after(self(), :reset_timer, 10_000)
    {:noreply, []}
  end
end
