defmodule TrafficControllerTest do
  use ExUnit.Case
  doctest TrafficController

  test "greets the world" do
    assert TrafficController.hello() == :world
  end
end
