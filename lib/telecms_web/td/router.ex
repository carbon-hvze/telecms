defmodule TelecmsWeb.Td.Router do
  alias Telecms.Auth
  require Logger

  # TODO add fsm handling of auth

  auth_fsm = %{}

  def handle_msg(
        %{
          "@type" => "updateAuthorizationState",
          "authorization_state" => %{"@type" => auth_state}
        },
        client_state,
        pipe_sync
      ) do
    # TODO add error check on sync call
    patch =
      case auth_state do
        "authorizationStateWaitTdlibParameters" ->
          Auth.get_tdlib_params(client_state.index) |> pipe_sync.()
          %{client_status: [:auth_flow]}

        "authorizationStateWaitEncryptionKey" ->
          pipe_sync.(%{"@type": "checkDatabaseEncryptionKey", encryption_key: ""})

        "authorizationStateReady" ->
          %{client_status: [:ready]}

        # TODO remove mock registration in release
        "authorizationStateWaitRegistration" ->
          pipe_sync.(%{"@type": "registerUser", first_name: "john", last_name: "doe"})

        _ ->
          %{}
      end

    Map.merge(%{auth_state: [auth_state]}, patch)
  end

  def handle_msg(
        %{"@type" => "updateOption", "name" => k, "value" => v},
        _client_state,
        _pipe_sync
      ) do
    %{td_options: Map.new([{k, v}])}
  end

  def handle_msg(%{"@__rpc" => "send_code"}, _client_state, pipe_sync) do
    number = Application.get_env(:telecms, :admin_phone_number)

    pipe_sync.(%{"@type": "setAuthenticationPhoneNumber", phone_number: number})
  end

  def handle_msg(%{"@__rpc" => "check_code", "value" => v}, _state, pipe_sync) do
    pipe_sync.(%{"@type": "checkAuthenticationCode", code: v})
  end

  def handle_msg(unknown, _, _) do
    msg = inspect(unknown) |> String.slice(0..7)
    Logger.warn("handled default #{msg}")
    %{}
  end
end
