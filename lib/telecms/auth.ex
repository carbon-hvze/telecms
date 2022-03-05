defmodule Telecms.Auth do
  def req_types() do
    ["tdlibParameters", "setTdlibParameters"]
  end

  def get_params(index) do
    default_params = Map.fetch!(index, "tdlibParameters")

    settings = %{
      "application_version" => "0.0.1",
      "device_model" => "Iphone",
      "system_language_code" => "en",
      "use_test_dc" => true
    }

    [:database_directory, :api_id, :api_hash]
    |> Enum.map(fn k -> {k, Application.get_env(:telecms, k)} end)
    |> Enum.into(%{})
    |> Map.merge(default_params)
    |> Map.merge(settings)
  end
end
