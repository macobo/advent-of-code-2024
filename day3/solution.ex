input = IO.read(:stdio, :eof)

matches1 = Regex.scan(~r/mul\((\d+),(\d+)\)/, input)

part1 = matches1
|> Enum.map(fn [_, a, b] -> String.to_integer(a) * String.to_integer(b) end)
|> Enum.sum()

IO.puts("Part 1: #{part1}")

matches2 = Regex.scan(~r/(?:mul\((\d+),(\d+)\))|(?:do\(\))|(?:don't\(\))/, input)

{_, part2} = matches2
|> Enum.reduce({true, 0}, fn
  ["do()"], {_multiply?, acc} ->
    {true, acc}
  ["don't()"], {_multiply?, acc} ->
    {false, acc}
  ["mul(" <> _, a, b], {true = _multiply?, acc} ->
    {true, acc + String.to_integer(a) * String.to_integer(b)}
  ["mul(" <> _, _, _], {false = _multiply?, acc} ->
    {false, acc}
end)

IO.puts("Part 2: #{part2}")
