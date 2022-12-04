defmodule AdventOfCode.Day03 do
  def part1(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&common_item_type/1)
    |> Enum.map(&item_type_priority/1)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.chunk_every(3)
    |> Enum.map(&intersection_item/1)
    |> Enum.map(&item_type_priority/1)
    |> Enum.sum()
  end

  defp common_item_type(rucksack) do
    compartment_size = trunc(byte_size(rucksack) / 2)
    {compartment_1, compartment_2} = rucksack |> String.split_at(compartment_size)
    intersection_item([compartment_1, compartment_2])
  end

  defp item_type_priority(item_type) do
    cond do
      item_type in ?a..?z -> item_type - ?a + 1
      item_type in ?A..?Z -> item_type - ?A + 27
    end
  end

  defp intersection_item(bags) do
    [result] =
      bags
      |> Enum.map(&MapSet.new(:binary.bin_to_list(&1)))
      |> Enum.reduce(&MapSet.intersection(&1, &2))
      |> MapSet.to_list()

    result
  end
end
