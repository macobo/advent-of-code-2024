# Thinking through the problem.
# 1. We need to find lines w/ points and find 1/3 and 2/3 points

defmodule Graph do
  def cross_product(list) do
    for a <- list, b <- list, b > a do
      {a, b}
    end
  end

  def line_points({x1, y1}, {x2, y2}) do
    dx = x2 - x1
    dy = y2 - y1
    [
      {x1 - dx, y1 - dy},
      {x2 + dx, y2 + dy}
    ]
  end

  def line_points_part2(height, width, {x1, y1}, {x2, y2}) do
    dx = x2 - x1
    dy = y2 - y1

    Enum.concat([
      check_in_bounds(height, width, {x1, y1}, fn {x, y} -> {x - dx, y - dy} end),
      check_in_bounds(height, width, {x2, y2}, fn {x, y} -> {x + dx, y + dy} end)
    ])
  end

  def check_in_bounds(height, width, {x, y}, next_f, acc \\ []) do
    if x >= 0 && x < width && y >= 0 && y < height do
      check_in_bounds(height, width, next_f.({x, y}), next_f, [{x, y} | acc])
    else
      acc
    end
  end
end

input = IO.read(:stdio, :eof)
|> String.trim()
|> String.split("\n")
|> Enum.map(&String.to_charlist/1)

height = input |> length()
width = input |> List.first() |> length()

nodes = input
  |> Enum.with_index()
  |> Enum.flat_map(fn {line, x} ->
    line
    |> Enum.with_index()
    |> Enum.flat_map(fn
      {?., _} -> []
      {char, y} -> [{char, {x, y}}]
    end)
  end)
  |> Enum.group_by(fn {char, _} -> char end, fn {_, pos} -> pos end)

part1 = nodes
  |> Enum.flat_map(fn {_char, positions} ->
    positions
    |> Graph.cross_product()
    |> Enum.flat_map(fn {a, b} ->
      Graph.line_points(a, b)
    end)
  end)
  |> Enum.uniq()
  |> Enum.filter(fn {x, y} -> x >= 0 && x < width && y >= 0 && y < height end)

IO.puts("Part 1: #{length(part1)}")


part2 = nodes
|> Enum.flat_map(fn {_char, positions} ->
  positions
  |> Graph.cross_product()
  |> Enum.flat_map(fn {a, b} ->
    Graph.line_points_part2(height, width, a, b)
  end)
end)
|> Enum.uniq()

IO.puts("Part 2: #{length(part2)}")
