defmodule Advent.RoomName do
  defstruct name: "", sector_id: 0, checksum: "", decrypted_name: ""
  
  @doc ~S"""
  Sums the sector IDs of all real rooms in the given list of encrypted room names.
  
    iex> Advent.RoomName.sum_real_sector_ids("aaaaa-bbb-z-y-x-123[abxyz]\na-b-c-d-e-f-g-h-987[abcde]\nnot-a-real-room-404[oarel]\ntotally-real-room-200[decoy]")
    1514
  """
  def sum_real_sector_ids(rooms) do
    get_real_rooms(rooms)
    |> Enum.reduce(0, fn (r, sum) -> sum + r.sector_id end)
  end
  
  @doc """
  Decrypts the names of all of the real rooms in the given list of encrypted room names.
  
    iex> Advent.RoomName.decrypt_real_rooms("qzmt-zixmtkozy-ivhz-343[zimth]")
    [%Advent.RoomName{name: "qzmt-zixmtkozy-ivhz", sector_id: 343, checksum: "zimth", decrypted_name: "very encrypted name"}]
  """
  def decrypt_real_rooms(rooms) do
    get_real_rooms(rooms)
    |> Enum.map(&decrypt/1)
  end
  
  defp get_real_rooms(rooms) do
    String.split(rooms)
    |> Enum.map(&parse/1)
    |> Enum.filter(fn r -> r != nil end)
    |> Enum.filter(&is_real/1)
  end
  
  @doc ~S"""
  Parses an encrypted room name string into an Advent.RoomName struct.
  
    iex> Advent.RoomName.parse("aaaaa-bbb-z-y-x-123[abxyz]")
    %Advent.RoomName{name: "aaaaa-bbb-z-y-x", sector_id: 123, checksum: "abxyz"}
    
    iex> Advent.RoomName.parse("a-b-c-d-e-f-g-h-987[abcde]")
    %Advent.RoomName{name: "a-b-c-d-e-f-g-h", sector_id: 987, checksum: "abcde"}
  """
  def parse(room) do
    r = Regex.named_captures(~r/^(?<name>[a-z\-]+)\-(?<sector_id>[0-9]+)\[(?<checksum>[a-z]+)\]$/, room, capture: :all_but_first)
    case r do
      nil -> nil
      _ -> %__MODULE__{
        name: r["name"],
        sector_id: String.to_integer(r["sector_id"]),
        checksum: r["checksum"]
      }
    end
  end
  
  @doc ~S"""
  Checks if a parsed room name is for a real room.
  
    iex> Advent.RoomName.is_real(%Advent.RoomName{name: "aaaaa-bbb-z-y-x", sector_id: 123, checksum: "abxyz"})
    true
    
    iex> Advent.RoomName.is_real(%Advent.RoomName{name: "a-b-c-d-e-f-g-h", sector_id: 987, checksum: "abcde"})
    true
    
    iex> Advent.RoomName.is_real(%Advent.RoomName{name: "not-a-real-room", sector_id: 404, checksum: "oarel"})
    true
    
    iex> Advent.RoomName.is_real(%Advent.RoomName{name: "totally-real-room", sector_id: 200, checksum: "decoy"})
    false
  """
  def is_real(%__MODULE__{name: name, checksum: checksum}) do
    calc_checksum = count_letters_in(name)
    |> Enum.sort(&compare_counts/2)
    |> Enum.take(5)
    |> Enum.map(fn {l, _count} -> Atom.to_string(l) end)
    |> Enum.join()
    
    calc_checksum == checksum
  end
  
  @doc """
  Decrypts the name of the given room
  
    iex> Advent.RoomName.decrypt(%Advent.RoomName{name: "qzmt-zixmtkozy-ivhz", sector_id: 343})
    %Advent.RoomName{name: "qzmt-zixmtkozy-ivhz", sector_id: 343, decrypted_name: "very encrypted name"}
  """
  def decrypt(%__MODULE__{name: name, sector_id: sector_id} = room) do
    # The sector ID gives us how far through the alphabet we need to shift each letter in the name
    shift_by = rem(sector_id, 26)
    
    decrypted = String.codepoints(name)
    |> Enum.map(fn (c) -> decrypt_char(c, shift_by) end)
    |> Enum.join
    
    %{ room | decrypted_name: decrypted}
  end
  
  defp decrypt_char("-", _), do: " "
  defp decrypt_char(<< c >>, shift_by) when (c + shift_by) > 122, do: << (c + shift_by) - 26 >>
  defp decrypt_char(<< c >>, shift_by), do: << c + shift_by >>
  
  defp count_letters_in(name) do
    String.replace(name, "-", "")
    |> String.codepoints()
    |> Enum.map(&String.to_atom/1)
    |> Enum.reduce(%{}, fn (l, counts) -> 
      case Map.has_key?(counts, l) do
        true -> %{counts | l => counts[l] + 1}
        false -> Map.put(counts, l, 1)
      end
    end)
    |> Map.to_list
  end
  
  # Letters should be sorted by count (biggest first), with ties broken by alphabetisation
  defp compare_counts({_, count1}, {_, count2}) when count1 > count2, do: true
  defp compare_counts({letter1, count1}, {letter2, count2}) when count1 == count2 and letter1 < letter2, do: true
  defp compare_counts({letter1, count1}, {letter2, count2}) when count1 == count2 and letter1 == letter2, do: true
  defp compare_counts(_, _), do: false
end