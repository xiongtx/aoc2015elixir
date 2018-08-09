defmodule Day2Test do
  use ExUnit.Case
  doctest Day2

  test "Area" do
    assert Day2.area([2,3,4]) == 58
    assert Day2.area([1,1,10]) == 43
  end

  test "Total area" do
    assert Day2.total_area == 1606483
  end

  test "Ribbon area" do
    assert Day2.ribbon_area([2,3,4]) == 34
    assert Day2.ribbon_area([1,1,10]) == 14
  end

  test "Total ribbon area" do
    assert Day2.total_ribbon_area == 3842356
  end
end
