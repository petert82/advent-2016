defmodule Advent.MD5CrackerTest do
  use ExUnit.Case, async: true
  @moduletag timeout: 240000
  @moduletag :slow
  doctest Advent.MD5Cracker
end
