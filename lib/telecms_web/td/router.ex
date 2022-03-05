defmodule TelecmsWeb.Td.Router do
  alias Telecms.Auth
  require Logger
  # TODO add fsm handling of auth
  def handle_msg(%{"@type" => "updateAuthorizationState", "authorization_state" => _state}, index) do
    params = Auth.get_params(index)

    %{"@type": "setTdlibParameters", parameters: params}
  end

  def handle_msg(unknown, _) do
    Logger.warn("Unsupported message #{inspect(unknown)}")
    :noop
  end
end
