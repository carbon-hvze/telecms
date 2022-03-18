defmodule TelecmsWeb.ClientTest do
  use ExUnit.Case

  test "options are received correctly" do
    %{td_options: %{"version" => %{"value" => v}}} =
      GenServer.call(:client, %{
        "@type" => "updateOption",
        "name" => "version",
        "value" => %{"@type" => "optionValueString", "value" => "1.8.1"}
      })

    assert v == "1.8.1"

    %{td_options: %{"unix_time" => %{"value" => v}}} =
      GenServer.call(:client, %{
        "@type" => "updateOption",
        "name" => "unix_time",
        "value" => %{"@type" => "optionValueInteger", "value" => "1646839334"}
      })

    assert v == "1646839334"

    %{td_options: %{"version" => %{"value" => opt1}, "unix_time" => %{"value" => opt2}}} =
      GenServer.call(:client, %{
        "@type" => "updateOption",
        "name" => "version",
        "value" => %{"@type" => "optionValueString", "value" => "1.8.2"}
      })

    assert opt1 == "1.8.2"
    assert opt2 == "1646839334"
  end
end
