defmodule Advent.BlockDistance do
  @moduledoc """
  Day 1
  """
  
  def from_directions(directions) do
    String.split(directions, ", ")
    |> Enum.map(&parse_direction/1)
    |> Enum.reduce({0, 0, 0}, &apply_direction/2)
    |> coords_to_distance
  end
  
  defp parse_direction("L" <> distance), do: {-90, String.to_integer(distance)}
  defp parse_direction("R" <> distance), do: {90, String.to_integer(distance)}
  
  defp apply_direction({heading_change, distance}, {heading, x, y}) do
    get_new_heading(heading, heading_change)
    |> move_in_heading(distance, x, y)
  end
  
  defp get_new_heading(0, -90), do: 270
  defp get_new_heading(270, 90), do: 0
  defp get_new_heading(old_heading, change_degrees), do: old_heading + change_degrees
  
  defp move_in_heading(0, distance, x, y), do: {0, x, y + distance}
  defp move_in_heading(90, distance, x, y), do: {90, x + distance, y}
  defp move_in_heading(180, distance, x, y), do: {180, x, y - distance}
  defp move_in_heading(270, distance, x, y), do: {270, x - distance, y}
  
  defp coords_to_distance({_, x, y}), do: abs(x) + abs(y)
  
end