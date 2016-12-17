defmodule Advent.TriangleDetector do
  
  @doc ~S"""
  Counts how many lines in the input represent possible triangles.
  
    iex> Advent.TriangleDetector.count_possible("3 4 5")
    1
    
    iex> Advent.TriangleDetector.count_possible("3 4 5\n5 10 25")
    1
    
    iex> Advent.TriangleDetector.count_possible("3 4 5\n5 10 25\n30 40 50")
    2
  """
  def count_possible(input) do
    String.split(input, "\n")
    |> Enum.map(&parse_line/1)
    |> Enum.filter(&is_possible/1)
    |> Enum.count
  end
  
  defp parse_line(line) do
    String.split(line)
    |> Enum.map(&String.to_integer/1)
  end
  
  defp is_possible([a, b, c]) when (a + b > c) and (a + c > b) and (b + c > a), do: true
  defp is_possible(_), do: false
end