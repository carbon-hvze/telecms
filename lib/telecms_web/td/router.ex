defmodule TelecmsWeb.Td.Router do
  alias Telecms.Auth
  require Logger

  # TODO add fsm handling of auth

  def handle_msg(
        %{
          "@type" => "updateAuthorizationState",
          "authorization_state" => %{"@type" => auth_state}
        },
        client_state,
        pipe_sync
      ) do
    case auth_state do
      "authorizationStateWaitTdlibParameters" ->
        params = Auth.get_params(client_state.index)
        resp = pipe_sync.(%{"@type": "setTdlibParameters", parameters: params})
        {:ok, %{client_status: :auth_flow}}

      "authorizationStateWaitEncryptionKey" ->
        pipe_sync.(%{"@type": "checkDatabaseEncryptionKey", encryption_key: ""})
        {:ok, %{}}

      "authorizationStateReady" ->
        resp = pipe_sync.(%{"@type": "getChats", limit: 32})
        IO.inspect(resp)
        {:ok, %{client_status: :ready}}
    end
  end

  def handle_msg(
    %{"@type" => "updateOption", "name" => k, "value" => v},
    client_state,
    pipe_sync
  ) do
    {:ok, %{td_options: Map.new([{k, v}])}}
  end

  def handle_msg(unknown, _, _) do
    Logger.warn("Unsupported message #{inspect(unknown)}")
    {:ok, %{}}
  end
end
