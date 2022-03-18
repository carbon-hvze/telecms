defmodule TestBackend do
  require Logger
  use GenServer

  def start_link(init_arg) do
    GenServer.start_link(__MODULE__, init_arg, name: :backend)
  end

  @impl true
  def init(_init_arg) do
    {:ok, %{calls: []}}
  end

  @impl true
  def handle_info(data, state) do
    GenServer.cast(:client, data)
    {:noreply, state}
  end

  @impl true
  def handle_call(data, _from, %{calls: cs}) do
    new_state = %{calls: cs ++ [data]}
    {:reply, new_state, new_state}
  end
end
