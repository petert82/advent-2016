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
  
  @doc ~S"""
  Counts how many vertical sets of 3 numbers in the input represent possible triangles.
  
  For example, this input would have 2 possible triangles - in the 1st and 3rd columns:
  
   3  5 30
   4 10 40
   5 25 50
  
    iex> Advent.TriangleDetector.count_possible_by_col("3 5 30\n4 10 40\n5 25 50")
    2
  """
  def count_possible_by_col(input) do
    String.split(input, "\n")
    |> Enum.map(&parse_line/1)
    # We need groups of 3 lines to get vertical triangle side lengths
    |> Enum.chunk(3)
    # Collect the vertical triangle sides from the three lines so that they are grouped by the 
    # (possible) triangle that they belong to 
    |> Enum.flat_map(&rotate/1)
    |> Enum.filter(&is_possible/1)
    |> Enum.count
  end
  
  defp parse_line(line) do
    String.split(line)
    |> Enum.map(&String.to_integer/1)
  end
  
  defp is_possible([a, b, c]) when (a + b > c) and (a + c > b) and (b + c > a), do: true
  defp is_possible(_), do: false
  
  defp rotate([[a,b,c], [d,e,f], [g,h,i]]), do: [[a,d,g], [b,e,h], [c,f,i]]
end