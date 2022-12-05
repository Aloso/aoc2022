defmodule AdventOfCode.Day04 do
  def part1(input), do: count_regions(input, &regions_overlap_fully?/1)
  def part2(input), do: count_regions(input, &regions_overlap?/1)

  def count_regions(input, f) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn r -> r |> String.split(",") |> Enum.map(&parse_region/1) end)
    |> Enum.filter(f)
    |> Enum.count()
  end

  defp parse_region(region) do
    [first, last] = region |> String.split("-") |> Enum.map(&String.to_integer/1)
    first..last
  end

  defp regions_overlap?([range1, range2]) do
    !Range.disjoint?(range1, range2)
  end

  defp regions_overlap_fully?([range1, range2]) do
    contains(range1, range2) or contains(range2, range1)
  end

  defp contains(s1..e1, s2..e2) do
    s1 <= s2 and e1 >= e2
  end
end
