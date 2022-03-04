defmodule TelecmsWeb.Td.Router do
  require Logger

  ## TODO move handling logic to telecms.[] modules

  def handle_msg(%{"@type" => "updateAuthorizationState", "authorization_state" => state}) do

    tail = %{
      "application_version" => "0.0.1",
      "device_model" => "Iphone",
      "enable_storage_optimizer" => false,
      "files_directory" => "",
      "ignore_file_names" => false,
      "system_language_code" => "en",
      "system_version" => "",
      "use_chat_info_database" => false,
      "use_file_database" => false,
      "use_message_database" => false,
      "use_secret_chats" => false,
      "use_test_dc" => true
    }

    params =
      [:database_directory, :api_id, :api_hash]
      |> Enum.map(fn k -> {k, Application.get_env(:telecms, k)} end)
      |> Enum.into(%{})
      |> Map.merge(tail)

    %{"@type": "setTdlibParameters", "parameters": params}
  end

  def handle_msg(unknown) do
    Logger.warn("Unsupported message #{inspect(unknown)}")
    :noop
  end
end
