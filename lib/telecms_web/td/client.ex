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
    case Router.handle_msg(data, state.index, pipe_sync()) do
      :ok -> :noop
      error -> Logger.warn(error)
    end

    {:noreply, state}
  end

  def pipe_sync() do
    fn r -> GenServer.call(:backend, r) end
  end
end
