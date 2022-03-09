defmodule TelecmsWeb.ClientTest do
  use ExUnit.Case

  setup do
    pid = start_supervised!(TelecmsWeb.Td.Client)

    %{client_pid: pid}
  end

  test "options are received correctly" do
    %{td_options: %{"version" => %{"value" => v}}} =
      GenServer.call(:client, %{
        "@type" => "updateOption",
        "name" => "version",
        "value" => %{"@type" => "optionValueString", "value" => "1.8.1"}
      })

    assert v == "1.8.1"

    GenServer.call(:client, %{
      "@type" => "updateOption",
      "name" => "unix_time",
      "value" => %{"@type" => "optionValueInteger", "value" => "1646839334"}
    })
  end
end
