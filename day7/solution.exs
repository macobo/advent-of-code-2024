input = IO.read(:stdio, :eof)
  |> String.trim()
  |> String.split("\n")
  |> Enum.map(fn line ->
    [target, rest] = String.split(line, ": ")

    {
      target |> String.to_integer(),
      rest |> String.split(" ") |> Enum.map(&String.to_integer/1)
    }
  end)

defmodule Arithmetic do
  def calibration_part_1(target, numbers) do
    calibration(target, numbers, 0, false)
  end

  def calibration_part_2(target, numbers) do
    calibration(target, numbers, 0, true)
  end

  def calibration(target, _, acc, _) when acc > target, do: 0
  def calibration(target, [], acc, _) when acc == target, do: target
  def calibration(_, [], _, _), do: 0

  def calibration(target, [head | tail], acc, allow_concat) do
    Enum.max([
      calibration(target, tail, acc + head, allow_concat),
      if acc != 0 do
        calibration(target, tail, acc * head, allow_concat)
      else
        0
      end,
      if allow_concat do
        calibration(target, tail, concat(acc, head), true)
      else
        0
      end
    ])
  end

  def concat(0, head), do: head
  def concat(a, b), do: String.to_integer("#{a}#{b}")
end

part1 = input
  |> Task.async_stream(fn {target, numbers} -> Arithmetic.calibration_part_1(target, numbers) end)
  |> Enum.map(fn {:ok, result} -> result end)
  |> Enum.sum()

IO.puts("Part 1: #{part1}")

part2 = input
  |> Task.async_stream(fn {target, numbers} -> Arithmetic.calibration_part_2(target, numbers) end)
  |> Enum.map(fn {:ok, result} -> result end)
  |> Enum.sum()

IO.puts("Part 2: #{part2}")
