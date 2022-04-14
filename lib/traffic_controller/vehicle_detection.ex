defmodule TrafficController.VehicleDetection do
  @moduledoc """
  This is the state machine for the traffic lights.
  """
  use GenServer

  require Logger

  alias TrafficController.LightController, as: Lights

  def start_link(_) do
    GenServer.start_link(__MODULE__, 0, name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end

  def vehicle_detected do
    GenServer.cast(__MODULE__, :vehicle_detected)
  end

  def vehicle_waiting? do
    GenServer.call(__MODULE__, :vehicle_waiting?)
  end

  def handle_info(:can_go?, state) do
    state = if Lights.can_go?() and state > 0 do
      state - 1
    else
      state
    end

    Process.send_after(self(), :can_go?, 5_000)

    Logger.info("Number of vehicles waiting: #{inspect state}")
    {:noreply, state}
  end

  def handle_cast(:vehicle_detected, state) do
    Logger.info "Number of vehicles detected: #{inspect state + 1}"
    Process.send_after(self(), :can_go?, 5000)
    {:noreply, state + 1}
  end

  def handle_call(:vehicle_waiting?, _from, state) do
    Logger.info "Waiting vehicles: #{inspect state}"
    {:reply, state > 0, state}
  end

end
