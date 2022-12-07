defmodule AdventOfCode.Day06Test do
  use ExUnit.Case

  import AdventOfCode.Day06

  test "part1" do
    input = "mjqjpqmgbljsphdztnvjfqwrcgsmlb"
    result = part1(input)

    assert result == 7
  end

  test "part2" do
    input = "mjqjpqmgbljsphdztnvjfqwrcgsmlb"
    result = part2(input)

    assert result == 19
  end
end
