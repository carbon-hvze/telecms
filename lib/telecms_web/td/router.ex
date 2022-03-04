defmodule TelecmsWeb.Td.Router do
  require Logger

  ## TODO move handling logic to telecms.[] modules

  def handle_msg(%{"@type" => "updateAuthorizationState", "authorization_state" => state}) do
    tail = %{"@type": "setTdlibParameters", use_test_dc: "true"}

    [:database_directory, :api_id, :api_hash]
    |> Enum.map(fn k -> {k, Application.get_env(:telecms, k)} end)
    |> Enum.into(%{})
    |> Map.merge(tail)
  end

  def handle_msg(unknown) do
    Logger.warn("Unsupported message #{inspect(unknown)}")
    :noop
  end
end
