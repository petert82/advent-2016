defmodule Advent.MD5Cracker do
  @doc """
  Works out the password for the given door ID using the rules for part 1 of day 5.
  
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
  
  @doc """
  Works out the password for the given door ID using the rules for part 2 of day 5.
  
    iex> Advent.MD5Cracker.crack_with_pos("abc")
    "05ace8e3"
  """
  def crack_with_pos(door_id) do
    _crack_with_pos(door_id, 0, %{
      "0" => "_",
      "1" => "_",
      "2" => "_",
      "3" => "_",
      "4" => "_",
      "5" => "_",
      "6" => "_",
      "7" => "_",
      count: 0
    })
  end
  
  defp _crack_with_pos(door_id, i, state)
  defp _crack_with_pos(_, _, %{count: count} = pw) when count == 8, do: _pw_state_to_string(pw)
  defp _crack_with_pos(door_id, i, state) do
    hash = :crypto.hash(:md5, door_id <> Integer.to_string(i))
    |> Base.encode16
    
    case hash do
      "00000" <> rest -> _get_char(rest, door_id, i, state)
        _ -> _crack_with_pos(door_id, i + 1, state)
        
    end
  end
  
  # Checks if the first char of hash_tail is a valid position in the PW, and if yes, puts the 2nd
  # char from hash_tail into the given position in the PW state.
  defp _get_char(hash_tail, door_id, i, state) do
    {pos, rest} = String.next_codepoint(hash_tail)
    
    case Map.has_key?(state, pos) and Map.get(state, pos) == "_" do
      true -> _crack_with_pos(door_id, i + 1, _update_state(state, pos, String.first(rest)))
      false -> _crack_with_pos(door_id, i + 1, state)
    end
  end
  
  # Sets the PW state char at `pos` to `pw_char` and increments the count of found characters.
  defp _update_state(state, pos, pw_char) do
    new_state = Map.put(%{ state | count: state.count + 1 }, pos, pw_char)
    _pw_state_to_string(new_state) |> IO.puts
    new_state
  end
  
  defp _pw_state_to_string(pw) do
    pw_string = pw["0"] <> pw["1"] <> pw["2"] <> pw["3"] <> pw["4"] <> pw["5"] <> pw["6"] <> pw["7"]
    String.downcase(pw_string)
  end
end