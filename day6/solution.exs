grid = IO.read(:stdio, :eof)
|> String.trim()
|> String.split("\n")
|> Enum.map(&String.to_charlist/1)

defmodule GuardGrid do
  def start_position(grid) do
    grid
    |> Enum.with_index()
    |> Enum.find_value(fn {line, x} ->
      y = Enum.find_index(line, &(&1 == ?^))
      if(y, do: {x, y}, else: false)
    end)
  end

  def out_of_bounds?(grid,{ x, y }) do
    x < 0 || y < 0 || x >= length(grid) || y >= length(hd(grid))
  end

  def search_part_1(grid) do
    grid
    |> search()
    |> MapSet.size()
  end

  defp search(grid) do
    pos = start_position(grid)
    visited = search(grid, pos, {-1, 0}, MapSet.new([{pos, {-1, 0}}]), nil)

    visited |> Enum.map(fn {pos, _} -> pos end) |> MapSet.new()
  end

  defp search(grid, pos, delta, visited, fake_obstacle) do
    next = move(pos, delta)

    cond do
      out_of_bounds?(grid, pos) -> visited
      out_of_bounds?(grid, next) -> search(grid, next, delta, visited, fake_obstacle)
      MapSet.member?(visited, {next, delta}) -> :loop
      obstacle?(grid, next) or next == fake_obstacle -> search(grid, pos, turn(delta), visited, fake_obstacle)
      true -> search(grid, next, delta, MapSet.put(visited, {next, delta}), fake_obstacle)
    end
  end

  defp move({x, y}, {dx, dy}) do
    {x + dx, y + dy}
  end

  defp turn({-1, 0}), do: {0, 1}
  defp turn({0, 1}), do: {1, 0}
  defp turn({1, 0}), do: {0, -1}
  defp turn({0, -1}), do: {-1, 0}

  defp obstacle?(grid, {x, y}) do
    grid
    |> Enum.at(x)
    |> Enum.at(y)
    |> Kernel.==(?#)
  end

  def search_part_2(grid) do
    path = search(grid)
    pos = start_position(grid)

    path
    |> Task.async_stream(fn obstacle_pos ->
      search(grid, pos, {-1, 0}, MapSet.new([{pos, {-1, 0}}]), obstacle_pos) == :loop
    end)
    |> Enum.count(fn {:ok, is_loop} -> is_loop end)
  end
end

part1 = GuardGrid.search_part_1(grid)
IO.puts("Part 1: #{part1}")

part2 = GuardGrid.search_part_2(grid)
IO.puts("Part 2: #{part2}")
