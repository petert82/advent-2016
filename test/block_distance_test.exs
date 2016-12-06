defmodule Advent.BlockDistanceTest do
  use ExUnit.Case
  doctest Advent.BlockDistance

  test "calculates block distance" do
    assert Advent.BlockDistance.from_directions("R2, R2, R2") == 2
    assert Advent.BlockDistance.from_directions("R5, L5, R5, R3") == 12
    assert Advent.BlockDistance.from_directions("R1") == 1
    assert Advent.BlockDistance.from_directions("L1, L1, L1") == 1
    assert Advent.BlockDistance.from_directions("L1, L1, L1, L1") == 0
    assert Advent.BlockDistance.from_directions("R1, R1, R1, R1") == 0
  end
end
