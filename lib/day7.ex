defmodule Day7 do
  use Bitwise, only_operators: true
  @moduledoc """
  --- Day 7: Some Assembly Required ---

  This year, Santa brought little Bobby Tables a set of wires and bitwise
  logic gates! Unfortunately, little Bobby is a little under the recommended
  age range, and he needs help assembling the circuit.

  Each wire has an identifier (some lowercase letters) and can carry a 16-bit
  signal (a number from 0 to 65535). A signal is provided to each wire by a
  gate, another wire, or some specific value. Each wire can only get a signal
  from one source, but can provide its signal to multiple destinations. A gate
  provides no signal until all of its inputs have a signal.

  The included instructions booklet describes how to connect the parts
  together: x AND y -> z means to connect wires x and y to an AND gate, and
  then connect its output to wire z.

  For example:

  - 123 -> x means that the signal 123 is provided to wire x.

  - x AND y -> z means that the bitwise AND of wire x and wire y is provided
  to wire z.

  - p LSHIFT 2 -> q means that the value from wire p is left-shifted by 2 and
  then provided to wire q.

  - NOT e -> f means that the bitwise complement of the value from wire e is
  provided to wire f.

  Other possible gates include OR (bitwise OR) and RSHIFT (right-shift). If,
  for some reason, you'd like to emulate the circuit instead, almost all
  programming languages (for example, C, JavaScript, or Python) provide
  operators for these gates.

  For example, here is a simple circuit:

  123 -> x
  456 -> y
  x AND y -> d
  x OR y -> e
  x LSHIFT 2 -> f
  y RSHIFT 2 -> g
  NOT x -> h
  NOT y -> i

  After it is run, these are the signals on the wires:

  d: 72
  e: 507
  f: 492
  g: 114
  h: 65412
  i: 65079
  x: 123
  y: 456

  In little Bobby's kit's instructions booklet (provided as your puzzle
  input), what signal is ultimately provided to wire a?

  --- Part Two ---

  Now, take the signal you got on wire a, override wire b to that signal, and
  reset the other wires (including wire a). What new signal is ultimately
  provided to wire a?
  """

  def wire?(id) do
    Regex.match?(~r/[a-z]+/, id)
  end

  def parse_provide(s) do
    ~r/([a-z]+|[0-9]+) -> ([a-z]+)/
    |> Regex.run(s, capture: :all_but_first)
    |> (fn [v, w] -> [
        :provide,
      (if wire?(v), do: String.to_atom(v), else: String.to_integer(v)),
        String.to_atom(w)]
      end).()
  end

  def parse_and_or(s) do
    ~r/([a-z]+|[0-9]+) (AND|OR) ([a-z]+|[0-9]+) -> ([a-z]+)/
    |> Regex.run(s, capture: :all_but_first)
    |> (fn [w1, op, w2, w3] ->
        [String.to_atom(String.downcase(op)),
        (if wire?(w1), do: String.to_atom(w1), else: String.to_integer(w1)),
         (if wire?(w2), do: String.to_atom(w2), else: String.to_integer(w2)),
         String.to_atom(w3)]
      end).()
  end

  def parse_not(s) do
    ~r/NOT ([a-z]+) -> ([a-z]+)/
    |> Regex.run(s, capture: :all_but_first)
    |> Enum.map(&String.to_atom/1)
    |> List.insert_at(0, :not)
  end

  def parse_shift(s) do
    ~r/([a-z]+) (LSHIFT|RSHIFT) ([0-9]+) -> ([a-z]+)/
    |> Regex.run(s, capture: :all_but_first)
    |> (fn [w1, op, v, w2] -> [
        String.to_atom(String.downcase(op)),
        String.to_atom(w1),
        String.to_integer(v),
        String.to_atom(w2)]
      end).()
  end

  def parse_instruction(s) do
    cond do
      Regex.match?(~r/(AND|OR)/, s) -> parse_and_or(s)
      Regex.match?(~r/NOT/, s) -> parse_not(s)
      Regex.match?(~r/(LSHIFT|RSHIFT)/, s) -> parse_shift(s)
      true -> parse_provide(s)
    end
  end

  def parse_input do
    :aoc2015elixir
    |> :code.priv_dir
    |> Path.join("day7.txt")
    |> File.read!
    |> String.split(~r/\n/, trim: true)
    |> Enum.map(&parse_instruction/1)
    |> Enum.map(&({List.last(&1), &1}))
    |> Map.new
  end

  def dep_wires(instruction) do
    instruction
    |> Enum.drop(1)
    |> Enum.drop(-1)
    |> Enum.filter(&is_atom/1)
  end

  def instructions_and_deps(instructions, m) do
    instructions
    |> Enum.reduce(%{}, fn ins, top_m ->
      Map.put(top_m, ins, dep_wires(ins) |> Enum.map(&(Map.get(m, &1))))
    end)
  end

  def add_dep(_, v, v), do: :ok
  def add_dep(g, v, w) do
    :digraph.add_vertex(g, w)
    :digraph.add_edge(g, w, v)
  end

  def topsort(ins_deps) do
    g = :digraph.new
    Enum.each(ins_deps, fn {ins, dep} ->
      :digraph.add_vertex(g, ins)
      Enum.each(dep, &(add_dep(g, ins, &1)))
    end)
    :digraph_utils.topsort(g)
  end

  def getval(w, state), do: if is_number(w), do: w, else: Map.get(state, w)

  def execute_instruction(ins, state) do
    new_val = case Enum.drop(ins, -1) do
                [:provide, w] -> getval(w, state)
                [:and, w1, w2] -> getval(w1, state) &&& getval(w2, state)
                [:or, w1, w2] -> getval(w1, state) ||| getval(w2, state)
                [:not, w] -> ~~~getval(w, state)
                [:lshift, w, v] -> getval(w, state) <<< v
                [:rshift, w, v] -> getval(w, state) >>> v
              end
    Map.put(state, List.last(ins), new_val)
  end

  def execute_instructions(instructions) do
    Enum.reduce(instructions, %{}, &execute_instruction/2)
  end

  def a_value(m) do
    Map.values(m)
    |> instructions_and_deps(m)
    |> topsort
    |> execute_instructions
    |> Map.get(:a)
  end

  def a_value_overridden(m) do
    a_value(Map.put(m, :b, [:provide, a_value(m), :b]))
  end
end
