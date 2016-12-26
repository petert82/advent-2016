door_id = "abbhdwsy"
# password = Advent.MD5Cracker.crack(door_id)
# IO.puts "The password is #{password}"

second_password = Advent.MD5Cracker.crack_with_pos(door_id)
IO.puts "The real password is #{second_password}"