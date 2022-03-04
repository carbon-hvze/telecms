defmodule TelecmsWeb.Td.Client do
  alias TelecmsWeb.Td.Router
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
    resp = Router.handle_msg(data)

    case resp do
      :noop -> :ok
      _ -> GenServer.cast(:backend, resp)
    end

    {:noreply, state}
  end
end
