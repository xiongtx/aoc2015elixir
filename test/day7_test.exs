defmodule Day7Test do
  use ExUnit.Case
  doctest Day7

  test "Wire a value" do
    assert Day7.a_value(Day7.parse_input) == 3176
  end

  test "Wire a value, with b overriden" do
    assert Day7.a_value_overridden(Day7.parse_input) == 14710
  end
end
