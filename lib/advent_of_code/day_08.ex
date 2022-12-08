defmodule AdventOfCode.Day08 do
  def part1(input) do
    input
    |> parse_forest()
    |> apply_in_all_directions(&visibilites_from_start/1, &visibilites_from_end/1)
    |> count_visible_trees()
  end

  def part2(input) do
    input
    |> parse_forest()
    |> apply_in_all_directions(&distances_from_start/1, &distances_from_end/1)
    |> get_max_scenic_score()
  end

  defp parse_forest(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn line -> String.to_charlist(line) |> Enum.map(&(&1 - ?0)) end)
  end

  defp apply_in_all_directions(forest, forwards_fn, backwards_fn) do
    left = forest |> Enum.map(forwards_fn)
    right = forest |> Enum.map(backwards_fn)
    top = forest |> transpose() |> Enum.map(forwards_fn) |> transpose()
    bottom = forest |> transpose() |> Enum.map(backwards_fn) |> transpose()

    [left, right, top, bottom]
  end

  defp visibilites_from_start(line), do: line |> get_visibilities_rev() |> Enum.reverse()
  defp visibilites_from_end(line), do: line |> Enum.reverse() |> get_visibilities_rev()

  defp get_visibilities_rev(line) do
    {visibilities, _} =
      for tree <- line, reduce: {[], -1} do
        {visibilities, view_height} ->
          if tree > view_height do
            {[true | visibilities], tree}
          else
            {[false | visibilities], view_height}
          end
      end

    visibilities
  end

  defp distances_from_start(line), do: line |> get_distances_rev() |> Enum.reverse()
  defp distances_from_end(line), do: line |> Enum.reverse() |> get_distances_rev()

  defp get_distances_rev(line) do
    {distances, _, _} =
      for tree <- line, reduce: {[], {0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 0} do
        {distances, blocking_trees, idx} ->
          distance = idx - elem(blocking_trees, tree)

          blocking_trees =
            for height <- 0..tree, reduce: blocking_trees do
              blocking_trees -> put_elem(blocking_trees, height, idx)
            end

          {[distance | distances], blocking_trees, idx + 1}
      end

    distances
  end

  defp count_visible_trees(forest_visibilities) do
    forest_visibilities
    |> Enum.zip()
    |> Enum.map(fn rows_tuple ->
      rows_tuple
      |> Tuple.to_list()
      |> Enum.zip()
      |> Enum.filter(fn {a, b, c, d} -> a or b or c or d end)
      |> Enum.count()
    end)
    |> Enum.sum()
  end

  defp get_max_scenic_score(forest_distances) do
    forest_distances
    |> Enum.zip()
    |> Enum.map(fn rows_tuple ->
      rows_tuple
      |> Tuple.to_list()
      |> Enum.zip()
      |> Enum.map(fn {a, b, c, d} -> a * b * c * d end)
      |> Enum.max()
    end)
    |> Enum.max()
  end

  def transpose(rows) do
    rows
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
  end
end
