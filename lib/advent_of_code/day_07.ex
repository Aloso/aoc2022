defmodule AdventOfCode.Day07 do
  def part1(input) do
    input
    |> parse_tree()
    |> get_dirs(max_size: 100_000)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> parse_tree()
    |> get_dir_sizes()
    |> find_deletion_candidate()
  end

  defp get_dirs(tree, max_size: max_size) do
    {dir_sizes, _} = get_dir_sizes(tree)
    Enum.filter(dir_sizes, &(&1 <= max_size))
  end

  defp find_deletion_candidate({dir_sizes, sum}) do
    required_space = sum - 40_000_000

    dir_sizes
    |> Enum.filter(&(&1 >= required_space))
    |> Enum.min()
  end

  defp get_dir_sizes(tree) do
    {dir_sizes, sum} =
      for {_, value} <- tree, reduce: {[], 0} do
        {dir_sizes, sum} ->
          if is_integer(value) do
            {dir_sizes, sum + value}
          else
            {sizes, child_sum} = get_dir_sizes(value)
            sum = sum + child_sum
            {sizes ++ dir_sizes, sum}
          end
      end

    {[sum | dir_sizes], sum}
  end

  defp parse_tree(input) do
    lines = input |> String.split("\n")

    {tree, _} =
      for line <- lines, reduce: {%{}, []} do
        {root, path} ->
          case line do
            "$ cd /" -> {root, []}
            "$ cd .." -> {root, tl(path)}
            "$ cd " <> dir -> {root, [dir | path]}
            "$ ls" -> {root, path}
            "dir " <> _ -> {root, path}
            "" -> {root, path}
            _ -> {append_rec(root, Enum.reverse(path), parse_file(line)), path}
          end
      end

    tree
  end

  defp parse_file(size_and_name) do
    [size, name] = String.split(size_and_name, " ")
    size = String.to_integer(size)
    {name, size}
  end

  defp append_rec(root, path, pair) do
    case path do
      [head | tail] ->
        Map.put(root, head, append_rec(Map.get(root, head, %{}), tail, pair))

      [] ->
        {key, value} = pair
        Map.put(root, key, value)
    end
  end
end
