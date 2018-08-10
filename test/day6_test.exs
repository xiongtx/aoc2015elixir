defmodule Day6Test do
  use ExUnit.Case
  doctest Day6

  test "Number lit" do
    assert Day6.num_lit(Day6.parse_input) == 377891
  end

  test "Total brightness" do
    assert Day6.total_brightness(Day6.parse_input) == 14110788
  end
end
