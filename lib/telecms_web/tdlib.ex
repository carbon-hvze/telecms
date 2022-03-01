defmodule TelecmsWeb.Tdlib do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, [])
  end

  @impl true
  def init(_opts) do
    # add error check on unix docker
    {_res, root_path} = File.cwd()
    tdlib_path = Application.fetch_env!(:telecms, :binary_path)

    state = %{port: Port.open({:spawn_executable, root_path <> tdlib_path}, [:binary, :line])}

    {:ok, state}
  end
end
