defmodule Grid do
  defstruct [:width, :height, :cells]

  def new(data) when is_binary(data) do
    cells =
      data
      |> String.split("\n")
      |> Enum.map(&String.to_charlist/1)

    %Grid{
      height: length(cells),
      width: length(hd(cells)),
      cells: cells
    }
  end

  @deltas [
    {0, 1},
    {1, 0},
    {0, -1},
    {-1, 0},
    {1, 1},
    {1, -1},
    {-1, 1},
    {-1, -1}
  ]

  defp at(grid, x, y) do
    grid.cells
    |> Enum.at(x)
    |> Enum.at(y)
  end

  def search_part_1(grid, word) do
    all_positions_with_deltas(grid)
    |> Enum.map(fn {{x, y}, delta} -> search_word(grid, {x, y}, delta, word) end)
    |> Enum.sum()
  end

  defp all_positions_with_deltas(grid) do
    for x <- 0..(grid.height - 1),
        y <- 0..(grid.width - 1),
        delta <- @deltas,
        do: {{x, y}, delta}
  end

  defp search_word(grid, xy, delta, word)

  defp search_word(_grid, _xy, _delta, []), do: 1
  defp search_word(_grid, {x, y}, _delta, _word) when x < 0 or y < 0, do: 0
  defp search_word(grid, {x, y}, _delta, _word) when x >= grid.height or y >= grid.width, do: 0

  defp search_word(grid, {x, y}, {dx, dy} = delta, [char | rest]) do
    if at(grid, x, y) == char do
      search_word(grid, {x + dx, y + dy}, delta, rest)
    else
      0
    end
  end

  def search_part_2(grid) do
    all_x_mas_starting_positions(grid)
    |> Enum.count()
  end

  def all_x_mas_starting_positions(grid) do
    for x <- 1..(grid.height - 2),
        y <- 1..(grid.width - 2),
        at(grid, x, y) == ?A,
        is_x_mas(grid, x, y),
        do: {x, y}
  end

  defp is_x_mas(grid, x, y) do
    diagonals = [
      [at(grid, x-1, y-1), at(grid, x, y), at(grid, x+1, y+1)],
      [at(grid, x-1, y+1), at(grid, x, y), at(grid, x+1, y-1)]
    ]

    diagonals
    |> Enum.all?(fn chars -> chars == ~c(MAS) or chars == ~c(SAM) end)
  end
end

grid = IO.read(:stdio, :eof)
  |> String.trim()
  |> Grid.new()

part1 = Grid.search_part_1(grid, ~c(XMAS))
IO.puts("Part 1: #{part1}")

part2 = Grid.search_part_2(grid)
IO.puts("Part 2: #{part2}")
