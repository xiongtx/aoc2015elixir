defmodule Day1 do
  @moduledoc """
  --- Day 1: Not Quite Lisp ---

  Santa was hoping for a white Christmas, but his weather machine's "snow"
  function is powered by stars, and he's fresh out! To save Christmas, he
  needs you to collect fifty stars by December 25th.

  Collect stars by helping Santa solve puzzles. Two puzzles will be made
  available on each day in the advent calendar; the second puzzle is unlocked
  when you complete the first. Each puzzle grants one star. Good luck!

  Here's an easy puzzle to warm you up.

  Santa is trying to deliver presents in a large apartment building, but he
  can't find the right floor - the directions he got are a little
  confusing. He starts on the ground floor (floor 0) and then follows the
  instructions one character at a time.

  An opening parenthesis, (, means he should go up one floor, and a closing
  parenthesis, ), means he should go down one floor.

  The apartment building is very tall, and the basement is very deep; he will
  never find the top or bottom floors.

  For example:

  - (()) and ()() both result in floor 0.
  - ((( and (()(()( both result in floor 3.
  - ))((((( also results in floor 3.
  - ()) and ))( both result in floor -1 (the first basement level).
  - ))) and )())()) both result in floor -3.

  To what floor do the instructions take Santa?

  --- Part Two ---

  Now, given the same instructions, find the position of the first character
  that causes him to enter the basement (floor -1). The first character in the
  instructions has position 1, the second character has position 2, and so on.

  For example:

  - ) causes him to enter the basement at character position 1.
  - ()()) causes him to enter the basement at character position 5.

  What is the position of the character that causes Santa to first enter the
  basement?
  """

  def what_floor do
    {:ok, input} = :code.priv_dir(:aoc2015elixir) |> Path.join("day1.txt") |> File.read
    chars = String.graphemes(input)
    n_up = chars |> Enum.filter(&(&1 == "(")) |> Enum.count
    n_down = chars |> Enum.filter(&(&1 == ")")) |> Enum.count
    n_up - n_down
  end

  def basement_position do
    {:ok, input} = :code.priv_dir(:aoc2015elixir) |> Path.join("day1.txt") |> File.read
    chars = String.graphemes(input)
    1..length(chars)
    |> Enum.zip(chars)
    |> Enum.reduce_while(0, fn {i, c}, acc ->
      if acc == 0 && c == ")" do
        {:halt, i}
      else
        {:cont, acc + if c == "(" do 1 else -1 end}
      end
    end)
  end
end
