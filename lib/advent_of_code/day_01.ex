defmodule AdventOfCode.Day01 do
  def part1(input) do
    input
    |> String.split("\n\n")
    |> Enum.map(&sum_calories/1)
    |> Enum.max()
  end

  def part2(input) do
    input
    |> String.split("\n\n")
    |> Enum.map(&sum_calories/1)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.sum()
  end

  def sum_calories(group) do
    group
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&elem(Float.parse(&1), 0))
    |> Enum.sum()
  end
end
