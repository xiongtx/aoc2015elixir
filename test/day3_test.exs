defmodule Day3Test do
  use ExUnit.Case
  doctest Day3

  test "Unique houses" do
    assert String.graphemes(">") |> Day3.unique_houses == 2
    assert String.graphemes("^>v<") |> Day3.unique_houses == 4
    assert String.graphemes("^v^v^v^v^v") |> Day3.unique_houses == 2
    assert Day3.parse_input |> Day3.unique_houses == 2572
  end

  test "Robo unique houses" do
    assert String.graphemes("^v") |> Day3.robo_unique_houses == 3
    assert String.graphemes("^>v<") |> Day3.robo_unique_houses == 3
    assert String.graphemes("^v^v^v^v^v") |> Day3.robo_unique_houses == 11
    assert Day3.parse_input |> Day3.robo_unique_houses == 2631
  end
end
