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
        resp = Auth.get_tdlib_params(client_state.index)
        pipe_sync.(resp)
        {:ok, %{client_status: :auth_flow, auth_state: auth_state}}

      "authorizationStateWaitEncryptionKey" ->
        pipe_sync.(%{"@type": "checkDatabaseEncryptionKey", encryption_key: ""})
        {:ok, %{auth_state: auth_state}}

      "authorizationStateReady" ->
        pipe_sync.(%{"@type": "getChats", limit: 32})
        {:ok, %{client_status: :ready, auth_state: auth_state}}

      _ ->
        Logger.warn("Unknown auth state #{inspect(auth_state)}")
        {:ok, %{auth_state: auth_state}}
    end
  end

  def handle_msg(
        %{"@type" => "updateOption", "name" => k, "value" => v},
        _client_state,
        _pipe_sync
      ) do
    {:ok, %{td_options: Map.new([{k, v}])}}
  end

  def handle_msg(
        %{"@__rpc" => method},
        client_state,
        pipe_sync
      ) do
    Logger.warn("handling rpc call #{inspect(method)}")

    case method do
      "get_state" ->
        {:ok, %{}}

      "send_code" ->
        Auth.get_phone_number(client_state.index) |> pipe_sync.()
        {:ok, %{}}
    end
  end

  def handle_msg(unknown, _, _) do
    Logger.warn("Unsupported message #{inspect(unknown)}")
    {:ok, %{}}
  end
end
