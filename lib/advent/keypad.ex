defmodule Advent.Keypad do
  @doc ~S"""
  Follows the given instructions to get a keypad code using a standard keypad layout (as shown 
  below).
  
  123
  456
  789
  
  Instructions are followed starting from the '5' key.
  
  For example:
    iex> Advent.Keypad.get_code("UD\nLL")
    "54"
    
    iex> Advent.Keypad.get_code("ULL\nRRDDD\nLURDL\nUUUUD")
    "1985"
  """
  def get_code(instructions) do
    String.split(instructions)
    |> Enum.map_reduce(5, fn (key_instructions, start_key) ->
      res = get_num_normal(key_instructions, start_key)
      {res, res}
    end)
    |> elem(0)
    |> Enum.join
  end
  
  defp get_num_normal(instructions, start)
  defp get_num_normal("", start), do: start
  defp get_num_normal("U" <> rest, start) when start > 3, do: get_num_normal(rest, start - 3)
  defp get_num_normal("D" <> rest, start) when start < 7, do: get_num_normal(rest, start + 3)
  defp get_num_normal("L" <> rest, start) when not start in [1,4,7], do: get_num_normal(rest, start - 1)
  defp get_num_normal("R" <> rest, start) when not start in [3,6,9], do: get_num_normal(rest, start + 1)
  defp get_num_normal(<<_::size(8)>> <> rest, start), do: get_num_normal(rest, start)
  
  @doc ~S"""
  Follows the given instructions to get a keypad code using a weird keypad layout (as shown 
  below).
  
      1
    2 3 4
  5 6 7 8 9
    A B C
      D
  
  Instructions are followed starting from the '5' key.
  
  For example:
    iex> Advent.Keypad.get_code_for_weird_keypad("UD\nLL")
    "55"
    
    iex> Advent.Keypad.get_code_for_weird_keypad("ULL\nRRDDD\nLURDL\nUUUUD")
    "5DB3"
  """
  def get_code_for_weird_keypad(instructions) do
    String.split(instructions)
    |> Enum.map_reduce(5, fn (key_instructions, start_key) ->
      res = get_num_weird(key_instructions, start_key)
      {res, res}
    end)
    |> elem(0)
    |>Enum.map(&num_to_hex/1)
    |> Enum.join
  end
  
  defp get_num_weird(instructions, start)
  defp get_num_weird("", start), do: start
  defp get_num_weird("U" <> rest, start) when start in [3,13], do: get_num_weird(rest, start - 2)
  defp get_num_weird("U" <> rest, start) when start in [6,7,8,10,11,12], do: get_num_weird(rest, start - 4)
  defp get_num_weird("D" <> rest, start) when start in [1,11], do: get_num_weird(rest, start + 2)
  defp get_num_weird("D" <> rest, start) when start in [2,3,4,6,7,8], do: get_num_weird(rest, start + 4)
  defp get_num_weird("L" <> rest, start) when start in [3,4,6,7,8,9,11,12], do: get_num_weird(rest, start - 1)
  defp get_num_weird("R" <> rest, start) when start in [2,3,5,6,7,8,10,11], do: get_num_weird(rest, start + 1)
  defp get_num_weird(<<_::size(8)>> <> rest, start), do: get_num_weird(rest, start)
  
  defp num_to_hex(10), do: "A"
  defp num_to_hex(11), do: "B"
  defp num_to_hex(12), do: "C"
  defp num_to_hex(13), do: "D"
  defp num_to_hex(num), do: Integer.to_string(num)
end