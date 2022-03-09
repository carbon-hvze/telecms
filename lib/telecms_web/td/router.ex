defmodule TelecmsWeb.Td.Router do
  alias Telecms.Auth
  require Logger

  # TODO add fsm handling of auth

  def handle_msg(
        %{"@type" => "updateAuthorizationState", "authorization_state" => %{"@type" => state}},
        index,
        pipe_sync
      ) do

    case state do
      "authorizationStateWaitTdlibParameters" ->
        params = Auth.get_params(index)
        pipe_sync.(%{"@type": "setTdlibParameters", parameters: params})
      "authorizationStateWaitEncryptionKey" ->
        Logger.warn("waiting for the key")
    end

    :ok
  end

  def handle_msg(unknown, _, _) do
    Logger.warn("Unsupported message #{inspect(unknown)}")
    :ok
  end
end
