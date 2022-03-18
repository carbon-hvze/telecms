defmodule Telecms.UtilsTest do
  alias Telecms.Utils
  use ExUnit.Case

  test "lists are concatenated" do
    assert Utils.deep_merge(%{a: [2]}, %{a: [1]}) == %{a: [1, 2]}
  end
end
