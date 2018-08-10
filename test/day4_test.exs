defmodule Day4Test do
  use ExUnit.Case
  doctest Day4

  test "5 leading zeros" do
    assert Day4.hash_number_leading_zeros(Day4.parse_input, 5) == 282749
  end

  test "6 leading zeros" do
    assert Day4.hash_number_leading_zeros(Day4.parse_input, 6) == 9962624
  end
end
