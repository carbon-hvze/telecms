defmodule Telecms.TdMetaTest do
  alias Telecms.TdMeta

  import Map

  use ExUnit.Case

  test "required types are converted" do
    index = TdMeta.init()

    supported = ["setTdlibParameters", "tdlibParameters"]

    for tp <- supported do
      assert has_key?(index, tp)
    end

    for [_, v] <- index do
      assert keys(v) |> List.first
    end
  end
end
