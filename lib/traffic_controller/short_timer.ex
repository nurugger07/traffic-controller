defmodule TrafficController.ShortTimer do
  use GenServer

  require Logger

  alias TrafficController.LightController, as: Lights

  def start_link(_) do
    GenServer.start_link(__MODULE__, [running: false], name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end

  def start_timer do
    GenServer.cast(__MODULE__, :start_timer)
  end

  def handle_info(:expire_timer, [running: true]) do
    Logger.info("Short Timer expired after 15 sec")

    Lights.transition()

    {:noreply, [running: false]}
  end

  def handle_info(:expire_timer, state) do
    {:noreply, state}
  end

  def handle_cast(:start_timer, [running: false]) do
    Process.send_after(self(), :expire_timer, 15000)
    {:noreply, [running: true]}
  end

  def handle_cast(_, state) do
    {:noreply, state}
  end
end
