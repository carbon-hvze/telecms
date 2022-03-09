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
  def handle_cast(data, state), do: handle_request(data, state)

  # can I exclude this fun in release?
  @impl true
  def handle_call(data, _pid, state) do
    {_, new_state} = handle_request(data, state)
    {:reply, new_state, new_state}
  end

  def deep_merge(%{} = state, %{} = patch) do
    Map.merge(state, patch, fn _k, v1, v2 -> deep_merge(v1, v2) end)
  end

  def deep_merge(_state, patch), do: patch

  def handle_request(data, state) do
    {status, patch} = Router.handle_msg(data, state, pipe_sync())

    case status do
      :ok ->
        {:noreply, deep_merge(state, patch)}

      error ->
        Logger.warn(error)
        {:noreply, state}
    end
  end

  def pipe_sync() do
    fn r -> GenServer.call(:backend, r) end
  end
end
