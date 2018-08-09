defmodule Day1Test do
  use ExUnit.Case
  doctest Day1

  test "Calculate floor" do
    assert Day1.what_floor == 74
  end

  test "Position of char that first enters basement" do
    assert Day1.basement_position == 1795
  end
end
