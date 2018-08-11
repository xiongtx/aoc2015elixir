defmodule Day8Test do
  use ExUnit.Case
  doctest Day8

  test "Total original - escaped length" do
    assert Day8.total_original_escaped_length(Day8.parse_input) == 1350
  end

  test "Total encoded - original length" do
    assert Day8.total_encoded_original_length(Day8.parse_input) == 2085
  end
end
