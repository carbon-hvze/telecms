defmodule TelecmsWeb.Td.Backend do
  use GenServer

  def start_link(init_arg) do
    GenServer.start_link(__MODULE__, init_arg, name: :backend)
  end

  @impl true
  def init(_init_arg) do
    # TODO add error check on unix docker
    {_res, root_path} = File.cwd()
    tdlib_path = Application.fetch_env!(:telecms, :binary_path)

    state = %{port: Port.open({:spawn_executable, root_path <> tdlib_path}, [:binary, :line])}

    {:ok, state}
  end

  @impl true
  def handle_info({_from, {:data, data}}, state) do
    ## TODO add multiline msg
    case data do
      {:eol, msg} -> pipe_data msg

    end
    {:noreply, state}
  end

  def pipe_data(msg) do
    GenServer.cast :client, msg
  end
end
