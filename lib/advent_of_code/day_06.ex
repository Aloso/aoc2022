defmodule AdventOfCode.Day06 do
  def part1(input), do: find_start_marker_index(input, 4)
  def part2(input), do: find_start_marker_index(input, 14)

  defp find_start_marker_index(input, marker_size) do
    (input
     |> String.to_charlist()
     |> Enum.chunk_every(marker_size, 1, :discard)
     |> Enum.find_index(&is_start_marker/1)) + marker_size
  end

  defp is_start_marker(list) do
    sorted = Enum.sort(list)
    sorted == Enum.dedup(sorted)
  end
end
