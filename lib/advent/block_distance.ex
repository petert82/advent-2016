defmodule Advent.BlockDistance do
  @moduledoc """
  Day 1
  """
  
  @doc """
  Takes a string containing directions and calculates how far away the endpoint of following those
  directions is in city block distance.
  
  For example:
  
    iex> Advent.BlockDistance.from_directions("R2, L3")
    5
  """
  def from_directions(directions) do
    String.split(directions, ", ")
    |> Enum.map(&parse_direction/1)
    |> Enum.reduce({0, 0, 0}, &apply_direction/2)
    |> coords_to_distance
  end
  
  @doc """
  The same as from_directions but returns the distance to the first location that is visited twice.
  
    iex> Advent.BlockDistance.from_directions_stop_on_repeat("R8, R4, R4, R8")
    4
  """
  def from_directions_stop_on_repeat(directions) do
    # Get the start and end points of each move that we make
    {moves, _final} = String.split(directions, ", ")
    |> Enum.map(&parse_direction/1)
    |> Enum.map_reduce({0, 0, 0}, &apply_direction_with_history/2)
    
    # Interpolate to find each point that we visit
    points = [ {0, 0} | Enum.flat_map(moves, &interpolate/1) ]
    
    # Find the first point we visit twice
    {x, y} = find_first_dup(points)
    
    coords_to_distance({0, x, y})
  end
  
  # Converts a direction (e.g. "L3") to a heading change in degrees & a move distance
  defp parse_direction("L" <> distance), do: {-90, String.to_integer(distance)}
  defp parse_direction("R" <> distance), do: {90, String.to_integer(distance)}
  
  # Applies a parsed direction to a heading & coord tuple, getting the resulting heading and coord
  defp apply_direction({heading_change, distance}, {heading, x, y}) do
    get_new_heading(heading, heading_change)
    |> move_in_heading(distance, x, y)
  end
  
  defp get_new_heading(old_heading, change_degrees)
  defp get_new_heading(0, -90), do: 270
  defp get_new_heading(270, 90), do: 0
  defp get_new_heading(old_heading, change_degrees), do: old_heading + change_degrees
  
  defp move_in_heading(0, distance, x, y), do: {0, x, y + distance}
  defp move_in_heading(90, distance, x, y), do: {90, x + distance, y}
  defp move_in_heading(180, distance, x, y), do: {180, x, y - distance}
  defp move_in_heading(270, distance, x, y), do: {270, x - distance, y}
  
  # Like apply_direction, but returns both the start and end locations
  defp apply_direction_with_history({heading_change, distance}, {heading, x, y} = old_pos) do
    new_pos = get_new_heading(heading, heading_change)
    |> move_in_heading(distance, x, y)
    {{old_pos, new_pos}, new_pos}
  end
  
  # Gets a list of each {x,y} point on the path from start_state to end_state. start_state is 
  # excluded from the result
  defp interpolate(states)
  defp interpolate({{_, s_x, s_y}, {0, f_x, f_y}}), do: interpolate_up(s_x, s_y, f_x, f_y, [])
  defp interpolate({{_, s_x, s_y}, {90, f_x, f_y}}), do: interpolate_right(s_x, s_y, f_x, f_y, [])
  defp interpolate({{_, s_x, s_y}, {180, f_x, f_y}}), do: interpolate_down(s_x, s_y, f_x, f_y, [])
  defp interpolate({{_, s_x, s_y}, {270, f_x, f_y}}), do: interpolate_left(s_x, s_y, f_x, f_y, [])
  
  defp interpolate_left(s_x, _s_y, f_x, _f_y, points) when s_x == f_x, do: points
  defp interpolate_left(s_x, s_y, f_x, f_y, points) do
    [ {s_x-1, s_y} | interpolate_left(s_x-1, s_y, f_x, f_y, points) ]
  end
  
  defp interpolate_right(s_x, _s_y, f_x, _f_y, points) when s_x == f_x, do: points
  defp interpolate_right(s_x, s_y, f_x, f_y, points) do
    [ {s_x+1, s_y} | interpolate_right(s_x+1, s_y, f_x, f_y, points) ]
  end
  
  defp interpolate_up(_s_x, s_y, _f_x, f_y, points) when s_y == f_y, do: points
  defp interpolate_up(s_x, s_y, f_x, f_y, points) do
    [ {s_x, s_y+1} | interpolate_up(s_x, s_y+1, f_x, f_y, points) ]
  end
  
  defp interpolate_down(_s_x, s_y, _f_x, f_y, points) when s_y == f_y, do: points
  defp interpolate_down(s_x, s_y, f_x, f_y, points) do
    [ {s_x, s_y-1} | interpolate_down(s_x, s_y-1, f_x, f_y, points) ]
  end
  
  defp find_first_dup(list), do: _find_first_dup(list, [])
  defp _find_first_dup([], _seen), do: nil
  defp _find_first_dup([h | tail], seen) do
    case h in seen do
      true -> h
      false -> _find_first_dup(tail, [h | seen])
    end
  end
  
  defp coords_to_distance({_, x, y}), do: abs(x) + abs(y)
end

# {0, 0}
# {8, 0}
# {8, -4}
# {4, -4}
# {4, 4}