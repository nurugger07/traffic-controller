defmodule TrafficController.LightController do
  @moduledoc """
  This is the state machine for the traffic lights.
  """
  use GenServer

  require Logger

  alias TrafficController.ShortTimer
  alias TrafficController.LongTimer
  alias TrafficController.VehicleDetection

  @states %{
    S0: %{farm: :red, highway: :green},
    S1: %{farm: :red, highway: :yellow},
    S2: %{farm: :green, highway: :red},
    S3: %{farm: :yellow, highway: :red}
  }

  def start_link(_) do
    GenServer.start_link(__MODULE__, @states[:S0], name: __MODULE__)
  end

  def init(state) do
    {:ok, state, {:continue, :reset}}
  end

  def vehicle_detected do
    GenServer.call(__MODULE__, :vehicle_detected)
  end

  def can_go? do
    GenServer.call(__MODULE__, :can_go?)
  end

  def transition(timer \\ 0) do
    :timer.sleep(timer)
    GenServer.cast(__MODULE__, :transition)
  end

  def handle_continue(:reset, state) do
    Logger.info("Resetting intersection signals #{inspect state}")
    LongTimer.start_timer()
    {:noreply, state}
  end

  def handle_call(:can_go?, _from, state) when state in [%{farm: :green}, %{farm: :yellow}] do
    {:reply, true, state}
  end

  def handle_call(:can_go?, _from, state) do
    {:reply, false, state}
  end

  def handle_cast(:vehicle_detected, _from, %{farm: :red, highway: :green} = state) do
    ShortTimer.start_timer()
    {:noreply, state}
  end

  def handle_cast(:transition, state) do
    Logger.info("Current intersection signals #{inspect state}")
    new_state = if VehicleDetection.vehicle_waiting?() do
        case state do
          %{farm: :red, highway: :green} ->
            transition(2000)
            @states[:S1]
          %{farm: :red, highway: :yellow} ->
            transition(2000)
            @states[:S2]
          %{farm: :green, highway: :red} ->
            ShortTimer.start_timer()
            @states[:S3]
          %{farm: :yellow, highway: :red} ->
            transition(2000)
            @states[:S0]
        end
    else
      state
    end

    {:noreply, new_state}
  end

end
