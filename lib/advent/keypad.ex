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
      res = get_num(key_instructions, start_key)
      {res, res}
    end)
    |> elem(0)
    |> Enum.join
  end
  
  defp get_num(instructions, start)
  defp get_num("", start), do: start
  defp get_num("U" <> rest, start) when start > 3, do: get_num(rest, start - 3)
  defp get_num("D" <> rest, start) when start < 7, do: get_num(rest, start + 3)
  defp get_num("L" <> rest, start) when not start in [1,4,7], do: get_num(rest, start - 1)
  defp get_num("R" <> rest, start) when not start in [3,6,9], do: get_num(rest, start + 1)
  defp get_num(<<_::size(8)>> <> rest, start), do: get_num(rest, start)
end