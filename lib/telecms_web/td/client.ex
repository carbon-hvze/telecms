defmodule TelecmsWeb.Td.Client do
  alias TelecmsWeb.Td.Router
  alias Telecms.TdMeta

  require Logger

  use GenServer

  def start_link(init_arg) do
    GenServer.start_link(__MODULE__, init_arg, name: :client)
  end

  @impl true
  def init(_init_arg) do
    state = %{index: TdMeta.init()}
    {:ok, state}
  end

  @impl true
  def handle_cast(data, state) do
    {status, patch} = Router.handle_msg(data, state, pipe_sync())

    case status do
      :ok ->
        {:noreply, Map.merge(state, patch)}

      error ->
        Logger.warn(error)
        {:noreply, state}
    end
  end

  def pipe_sync() do
    fn r -> GenServer.call(:backend, r) end
  end
end
