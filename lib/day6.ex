defmodule Day6 do
  @moduledoc """
  --- Day 6: Probably a Fire Hazard ---

  Because your neighbors keep defeating you in the holiday house decorating
  contest year after year, you've decided to deploy one million lights in a
  1000x1000 grid.

  Furthermore, because you've been especially nice this year, Santa has mailed
  you instructions on how to display the ideal lighting configuration.

  Lights in your grid are numbered from 0 to 999 in each direction; the lights
  at each corner are at 0,0, 0,999, 999,999, and 999,0. The instructions
  include whether to turn on, turn off, or toggle various inclusive ranges
  given as coordinate pairs. Each coordinate pair represents opposite corners
  of a rectangle, inclusive; a coordinate pair like 0,0 through 2,2 therefore
  refers to 9 lights in a 3x3 square. The lights all start turned off.

  To defeat your neighbors this year, all you have to do is set up your lights
  by doing the instructions Santa sent you in order.

  For example:

  - turn on 0,0 through 999,999 would turn on (or leave on) every light.

  - toggle 0,0 through 999,0 would toggle the first line of 1000 lights,
  turning off the ones that were on, and turning on the ones that were off.

  - turn off 499,499 through 500,500 would turn off (or leave off) the middle
  four lights.

  After following the instructions, how many lights are lit?

  --- Part Two ---

  You just finish implementing your winning light pattern when you realize you
  mistranslated Santa's message from Ancient Nordic Elvish.

  The light grid you bought actually has individual brightness controls; each
  light can have a brightness of zero or more. The lights all start at zero.

  The phrase turn on actually means that you should increase the brightness of
  those lights by 1.

  The phrase turn off actually means that you should decrease the brightness
  of those lights by 1, to a minimum of zero.

  The phrase toggle actually means that you should increase the brightness of
  those lights by 2.

  What is the total brightness of all lights combined after following Santa's
  instructions?

  For example:

  - turn on 0,0 through 0,0 would increase the total brightness by 1.

  - toggle 0,0 through 999,999 would increase the total brightness by 2000000.

  """
  def grid do
    Stream.flat_map 1..1000, fn i ->
      Stream.map 1..1000, fn j -> {i, j} end
    end
  end

  def parse_instruction(s) do
    ~r/(turn on|turn off|toggle) ([0-9]+),([0-9]+) through ([0-9]+),([0-9]+)/
    |> Regex.run(s, capture: :all_but_first)
    |> (fn [ins, start_x, start_y, end_x, end_y] ->
      [case ins do
         "turn on" -> :on
         "turn off" -> :off
         "toggle" -> :toggle
       end,
       String.to_integer(start_x),
       String.to_integer(start_y),
       String.to_integer(end_x),
       String.to_integer(end_y)]
    end).()
  end

  def parse_input do
    :aoc2015elixir
    |> :code.priv_dir
    |> Path.join("day6.txt")
    |> File.read!
    |> String.split(~r/\n/, trim: true)
    |> Enum.map(&parse_instruction/1)
  end

  def applicable_instruction?({x, y}, [_, start_x, start_y, end_x, end_y]) do
    x >= start_x && x <= end_x && y >= start_y && y <= end_y
  end

  def execute_instruction(pos, state, instruction = [ins | _]) do
    if applicable_instruction?(pos, instruction) do
      case ins do
        :on -> :on
        :off -> :off
        :toggle -> if state == :on, do: :off, else: :on
      end
    else
      state
    end
  end

  def execute_instructions(pos, instructions) do
    instructions |> Enum.reduce(:off, &(execute_instruction(pos, &2, &1)))
  end

  def num_lit(instructions) do
    grid()
    |> Stream.map(&(execute_instructions(&1, instructions)))
    |> Stream.filter(&(&1 == :on))
    |> Enum.count
  end

  def execute_brightness_instruction(pos, state, instruction = [ins | _]) do
    if applicable_instruction?(pos, instruction) do
      case ins do
        :on -> state + 1
        :off -> max(0, state - 1)
        :toggle -> state + 2
      end
    else
      state
    end
  end

  def execute_brightness_instructions(pos, instructions) do
    instructions
    |> Enum.reduce(0, &(execute_brightness_instruction(pos, &2, &1)))
  end

  def total_brightness(instructions) do
    grid()
    |> Stream.map(&(execute_brightness_instructions(&1, instructions)))
    |> Enum.sum
  end
end
