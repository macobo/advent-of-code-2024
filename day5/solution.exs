[rules, sequences] =
  IO.read(:stdio, :eof)
  |> String.trim()
  |> String.split("\n\n")

rules = rules
  |> String.split("\n")
  |> Enum.map(fn line -> String.split(line, "|") |> List.to_tuple() end)
  |> MapSet.new()

sequences = sequences
  |> String.split("\n")
  |> Enum.map(fn line -> String.split(line, ",") end)

defmodule SequenceDetector do
  def score_part_1(rules, sequence) do
    if valid?(rules, sequence) do
      middle_value(sequence)
    else
      0
    end
  end

  def valid?(rules, sequence, visited \\ []) do
    case sequence do
      [] -> true
      [head | tail] -> not rule_preventing?(rules, head, visited) && valid?(rules, tail, [head | visited])
    end
  end

  defp rule_preventing?(rules, node, visited) do
    Enum.any?(visited, fn a -> MapSet.member?(rules, {node, a}) end)
  end

  defp middle_value(sequence) do
    sequence
    |> Enum.at(div(length(sequence), 2))
    |> String.to_integer()
  end

  def score_part_2(rules, sequence) do
    if not valid?(rules, sequence) do
      repair(rules, sequence) |> middle_value()
    else
      0
    end
  end

  defp repair(rules, sequence, acc \\ [])

  defp repair(_rules, [], acc), do: acc
  defp repair(rules, sequence, acc) do
    next = Enum.find(sequence, fn node -> not rule_put_before?(rules, node, sequence) end)

    if is_nil(next) do
      raise "No next node found"
    end

    repair(rules, sequence -- [next], acc ++ [next])
  end

  defp rule_put_before?(rules, node, sequence) do
    Enum.any?(sequence, fn a -> MapSet.member?(rules, {a, node}) end)
  end
end

part1 = Enum.map(sequences, &SequenceDetector.score_part_1(rules, &1)) |> Enum.sum()
IO.puts("Part 1: #{part1}")

part2 = Enum.map(sequences, &SequenceDetector.score_part_2(rules, &1)) |> Enum.sum()
IO.puts("Part 2: #{part2}")
