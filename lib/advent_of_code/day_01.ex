defmodule AdventOfCode.Day01 do
  def part1(input) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.map(&sum_calories/1)
    |> Enum.max()
  end

  def part2(input) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.map(&sum_calories/1)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.sum()
  end

  def sum_calories(group) do
    group
    |> String.split("\n", trim: true)
    |> Enum.map(
      &case Float.parse(&1) do
        {value, ""} -> value
        {_, error} -> raise(error)
      end
    )
    |> Enum.sum()
  end
end
