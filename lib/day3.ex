defmodule Day3  do
  @moduledoc """
  --- Day 3: Perfectly Spherical Houses in a Vacuum ---

  Santa is delivering presents to an infinite two-dimensional grid of houses.

  He begins by delivering a present to the house at his starting location, and
  then an elf at the North Pole calls him via radio and tells him where to
  move next. Moves are always exactly one house to the north (^), south (v),
  east (>), or west (<). After each move, he delivers another present to the
  house at his new location.

  However, the elf back at the north pole has had a little too much eggnog,
  and so his directions are a little off, and Santa ends up visiting some
  houses more than once. How many houses receive at least one present?

  For example:

  - > delivers presents to 2 houses: one at the starting location, and one to
  the east.

  - ^>v< delivers presents to 4 houses in a square, including twice to the
  house at his starting/ending location.

  - ^v^v^v^v^v delivers a bunch of presents to some very lucky children at
  only 2 houses.

  --- Part Two ---

  The next year , to speed up the process, Santa creates a robot version of
  himself, Robo-Santa, to deliver presents with him.

  Santa and Robo-Santa start at the same location (delivering two presents to
  the same starting house), then take turns moving based on instructions from
  the elf, who is eggnoggedly reading from the same script as the previous
  year.

  This year, how many houses receive at least one present?

  For example:

  - ^v delivers presents to 3 houses, because Santa goes north, and then
  Robo-Santa goes south.

  - ^>v< now delivers presents to 3 houses, and Santa and Robo-Santa end up
  back where they started.

  - ^v^v^v^v^v now delivers presents to 11 houses, with Santa going one
  direction and Robo-Santa going the other.
  """

  def parse_input do
    {:ok, input} = :code.priv_dir(:aoc2015elixir) |> Path.join("day3.txt") |> File.read
     String.graphemes(input)
  end

  def direction_to_delta(dir) do
    case dir do
      "^" -> {0, 1}
      "v" -> {0, -1}
      ">" -> {1, 0}
      "<" -> {-1, 0}
    end
  end

  def unique_houses(input) do
    input
    |> Enum.reduce({{0, 0}, MapSet.new |> MapSet.put({0, 0}), 1},
    fn dir, {{x, y}, all, n} ->
      {dx, dy} = direction_to_delta(dir)
      new_pos = {x + dx, y + dy}
      if MapSet.member?(all, new_pos) do
        {new_pos, all, n}
      else
        {new_pos, MapSet.put(all, new_pos), n + 1}
      end
    end)
    |> elem(2)
  end

  def swap_santa(who) do
    case who do
      :santa -> :robo_santa
      :robo_santa -> :santa
    end
  end

  def robo_unique_houses(input) do
    input
    |> Enum.reduce({%{santa: {0, 0}, robo_santa: {0, 0}}, MapSet.new |> MapSet.put({0, 0}), 1, :santa},
    fn dir, {positions, all, n, santa} ->
      {dx, dy} = direction_to_delta(dir)
      {x, y} = Map.get(positions, santa)
      new_pos = {x + dx, y + dy}
      new_positions = Map.put(positions, santa, new_pos)
      new_santa = swap_santa(santa)
      if MapSet.member?(all, new_pos) do
        {new_positions, all, n, new_santa}
      else
        {new_positions, MapSet.put(all, new_pos), n + 1, new_santa}
      end
    end)
    |> elem(2)
  end

end
