defmodule TelecmsWeb.Td.Client do
  alias TelecmsWeb.Td.Router
  alias Telecms.TdMeta
  alias Telecms.Utils

  require Logger

  use GenServer

  def start_link(init_arg) do
    GenServer.start_link(__MODULE__, init_arg, name: :client)
  end

  @impl true
  def init(_init_arg) do
    state = %{index: TdMeta.init(), client_status: [:not_ready], auth_state: []}
    {:ok, state}
  end

  @impl true
  def handle_cast(data, state), do: {:noreply, handle_request(data, state)}

  @impl true
  def handle_call(data, _pid, state) do
    new_state = handle_request(data, state)
    {:reply, new_state, new_state}
  end

  def handle_request(data, state) do
    Router.handle_msg(data, state, pipe_sync()) |> Utils.deep_merge(state)
  end

  def pipe_sync() do
    fn r -> GenServer.call(:backend, r) end
  end
end
