defmodule AdventOfCode.Day02 do
  def part1(input), do: sum_lines(input, &score_from_moves/1)

  def part2(input), do: sum_lines(input, &score_from_move_and_result/1)

  defp sum_lines(input, f) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(f)
    |> Enum.sum()
  end

  defp score_from_moves(line) do
    {opponent, me} = parse_line(line)
    calc_score(opponent, me)
  end

  defp score_from_move_and_result(line) do
    {opponent, result} = parse_line(line)
    me = calc_move(opponent, result)
    calc_score(opponent, me)
  end

  defp parse_line(line) do
    <<a, _, x>> = line
    {a - ?A + 1, x - ?X + 1}
  end

  def calc_score(opponent, me) do
    me + rem(me - opponent + 4, 3) * 3
  end

  def calc_move(opponent, result) do
    rem(opponent + result, 3) + 1
  end
end
