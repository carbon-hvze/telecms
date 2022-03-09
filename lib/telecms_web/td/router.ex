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
    # TODO add error check on sync call
    case auth_state do
      "authorizationStateWaitTdlibParameters" ->
        params = Auth.get_params(client_state.index)
        pipe_sync.(%{"@type": "setTdlibParameters", parameters: params})
        {:ok, %{client_status: :auth_flow}}

      "authorizationStateWaitEncryptionKey" ->
        pipe_sync.(%{"@type": "checkDatabaseEncryptionKey", encryption_key: ""})
        {:ok, %{}}

      "authorizationStateReady" ->
        pipe_sync.(%{"@type": "getChats", limit: 32})
        {:ok, %{client_status: :ready}}

      _ ->
        Logger.warn("Unknown auth state #{inspect(auth_state)}")
        {:ok, %{}}
    end
  end

  def handle_msg(
        %{"@type" => "updateOption", "name" => k, "value" => v},
        _client_state,
        _pipe_sync
      ) do
    {:ok, %{td_options: Map.new([{k, v}])}}
  end

  def handle_msg(unknown, _, _) do
    Logger.warn("Unsupported message #{inspect(unknown)}")
    {:ok, %{}}
  end
end
