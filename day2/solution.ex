data = IO.read(:stdio, :eof)
  |> String.trim()
  |> String.split("\n")
  |> Enum.map(&String.split/1)
  |> Enum.map(fn list -> Enum.map(list, &String.to_integer/1) end)

defmodule Day2 do
  def safe?(line) do
    asc = Enum.sort(line)
    desc = Enum.reverse(asc)

    (line == asc or line == desc) and gradual?(line)
  end

  def gradual?(line) do
    line
    |> Enum.zip(Enum.drop(line, 1))
    |> Enum.all?(fn {a, b} -> abs(a - b) <= 3 and a != b end)
  end

  def exists_safe_dropping_one?(line) do
    gen_all_but_one(line)
    |> Enum.any?(&safe?/1)
  end

  def gen_all_but_one(line) do
    (0..(length(line) - 1))
    |> Enum.map(fn to_drop_index ->
      Enum.with_index(line)
      |> Enum.filter(fn {_, index} -> index != to_drop_index end)
      |> Enum.map(fn {value, _} -> value end)
    end)
  end
end

IO.puts("Part 1: #{Enum.count(data, &Day2.safe?/1)}")
IO.puts("Part 2: #{Enum.count(data, &Day2.exists_safe_dropping_one?/1)}")
