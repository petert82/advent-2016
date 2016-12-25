defmodule Advent.MD5Cracker do
  @doc """
  Works out the password for the given door ID.
  
    iex> Advent.MD5Cracker.crack("abc")
    "18f47a30"
  """
  def crack(door_id) do
    _crack(door_id, 0, "")
    |> String.downcase
  end
  
  defp _crack(door_id, i, password)
  defp _crack(_, _, password) when byte_size(password) == 8, do: password
  defp _crack(door_id, i, password) do
    hash = :crypto.hash(:md5, door_id <> Integer.to_string(i))
    |> Base.encode16
    
    case hash do
      "00000" <> rest -> _crack(door_id, i + 1, password <> String.first(rest))
      _ -> _crack(door_id, i + 1, password)
    end
  end
end