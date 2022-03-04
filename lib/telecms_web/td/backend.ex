defmodule TelecmsWeb.Td.Backend do
  require Logger
  use GenServer

  def start_link(init_arg) do
    GenServer.start_link(__MODULE__, init_arg, name: :backend)
  end

  @impl true
  def init(_init_arg) do
    # TODO add error check on unix docker
    {_res, root_path} = File.cwd()
    tdlib_path = Application.fetch_env!(:telecms, :binary_path)

    state = %{
      port: Port.open({:spawn_executable, root_path <> tdlib_path}, [:binary, :line]),
      io: []
    }

    {:ok, state}
  end

  @impl true
  def handle_info({_port, {:data, data}}, state) do
    case data do
      {:eol, msg} ->
        %{io: buffer} = state
        pipe_data(buffer ++ [msg])
        {:noreply, Map.replace(state, :io, [])}

      {:noeol, chunk} ->
        %{io: io} = state
        {:noreply, Map.replace(state, :io, io ++ [chunk])}

      _shape ->
        Logger.warn("Unknown tdlib message shape")
        {:noreply, state}
    end
  end

  @impl true
  def handle_cast(data, state) do
    msg = Jason.encode!(data)

    IO.inspect(msg <> "\n")
    Kernel.send state.port, {self(), {:command, msg <> "\n"}}
    {:noreply, state}
  end

  def pipe_data(msg) do
    Jason.decode!(msg) |>
    then(fn parsed -> GenServer.cast :client, parsed end)
  end
end
