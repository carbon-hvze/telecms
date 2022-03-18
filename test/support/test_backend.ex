defmodule TestBackend do
  require Logger
  use GenServer

  def start_link(init_arg) do
    GenServer.start_link(__MODULE__, init_arg, name: :backend)
  end

  @impl true
  def init(_init_arg) do
    {:ok, %{}}
  end

  @impl true
  def handle_info(data, state) do
    GenServer.cast(:client, data)
    {:noreply, state}
  end

  @impl true
  def handle_call(_data, _from, state) do
    {:reply, {:status, :ok}, state}
  end
end
