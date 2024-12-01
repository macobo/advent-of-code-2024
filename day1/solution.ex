data = IO.read(:stdio, :eof)
|> String.trim()
|> String.split("\n")
|> Enum.map(&String.split/1)
|> Enum.map(fn list -> Enum.map(list, &String.to_integer/1) end)

[a, b] = (0..1)
|> Enum.map(fn i -> Enum.map(data, &Enum.at(&1, i)) |> Enum.sort() end)

part1 = Enum.zip(a, b)
  |> Enum.map(fn {a, b} -> abs(a - b) end)
  |> Enum.sum()

IO.puts("Part 1: #{part1}")

frequencies = Enum.frequencies(b)
part2 = a
  |> Enum.map(fn x -> x * Map.get(frequencies, x, 0) end)
  |> Enum.sum()

IO.puts("Part 2: #{part2}")
