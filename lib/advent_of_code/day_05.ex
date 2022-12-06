defmodule AdventOfCode.Day05 do
  def part1(input) do
    {stacks, rearrangements} = parse_input(input)

    for [quantity, from, to] <- rearrangements, reduce: stacks do
      stacks ->
        for _ <- 1..quantity, reduce: stacks do
          stacks ->
            [head | rest] = elem(stacks, from - 1)
            destination = elem(stacks, to - 1)
            stacks = put_elem(stacks, from - 1, rest)
            put_elem(stacks, to - 1, [head | destination])
        end
    end
    |> Tuple.to_list()
    |> Enum.flat_map(&Enum.take(&1, 1))
  end

  def part2(input) do
    {stacks, rearrangements} = parse_input(input)

    for [quantity, from, to] <- rearrangements, reduce: stacks do
      stacks ->
        {moved, rest} = stacks |> elem(from - 1) |> Enum.split(quantity)
        destination = elem(stacks, to - 1)
        stacks = put_elem(stacks, from - 1, rest)
        put_elem(stacks, to - 1, moved ++ destination)
    end
    |> Tuple.to_list()
    |> Enum.flat_map(&Enum.take(&1, 1))
  end

  defp parse_input(input) do
    [stacks, rearrangements] = String.split(input, "\n\n")
    {parse_stacks(stacks), parse_rearrangements(rearrangements)}
  end

  defp parse_stacks(stacks) do
    [numbering | stacks] = stacks |> String.split("\n") |> last_to_front()
    length = round(byte_size(numbering) / 4)

    stacks
    |> Enum.map(&parse_stack_row(&1, length))
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(fn stack -> Enum.filter(stack, &(&1 != nil)) end)
    |> List.to_tuple()
  end

  defp parse_stack_row(row, length) do
    parts = for <<x::binary-4 <- row <> " ">>, do: x
    fill_length = length - round(byte_size(row) / 4)

    Enum.map(parts, &parse_crate/1) ++ for _ <- 1..fill_length, do: nil
  end

  defp parse_crate(crate) do
    case crate do
      "    " -> nil
      <<"[", name::8, "] ">> -> name
    end
  end

  defp last_to_front(list) do
    [last | list] = Enum.reverse(list)
    [last | Enum.reverse(list)]
  end

  defp parse_rearrangements(rearrangements) do
    rearrangements
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse_rearrangement/1)
  end

  defp parse_rearrangement(rearrangement) do
    [_ | matches] = Regex.run(~r/move (\d+) from (\d+) to (\d+)/, rearrangement)
    matches |> Enum.map(&String.to_integer/1)
  end
end
