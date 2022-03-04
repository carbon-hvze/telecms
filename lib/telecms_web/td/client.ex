defmodule TelecmsWeb.Td.Client do
  use GenServer

  def start_link(init_arg) do
    GenServer.start_link(__MODULE__, init_arg, name: :client)
  end

  @impl true
  def init(_init_arg) do
    state = %{}
    {:ok, state}
  end

  @impl true
  def handle_cast(data, state) do
    IO.inspect data
    {:noreply, state}
  end
end
