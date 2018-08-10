defmodule Day5Test do
  use ExUnit.Case
  doctest Day5

  test "Number of nice strings" do
    assert Day5.number_nice(Day5.parse_input) == 236
  end

  test "Number of new nice strings" do
    assert Day5.new_number_nice(Day5.parse_input) == 51
  end
end
