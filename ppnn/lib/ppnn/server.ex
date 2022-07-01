defmodule Server do
  use GenServer

  ### 外部 API ###
  def start_link(state \\ []) do
    {:ok, pid} = GenServer.start_link(__MODULE__, state, name: __MODULE__)
    :global.register_name(:server, pid)
  end

  ### GenServer の実装 ###

  def init(state) do
    {:ok, state}
  end

  def handle_cast({:at_server, [msg, cnt, loop_num, start_time]}, _current_state) do
    # IO.puts("server: #{msg} #{cnt}")
    GenServer.cast(:global.whereis_name(:client), {:at_client, [msg, cnt, loop_num, start_time]})
    {:noreply, [msg, cnt, loop_num, start_time]}
  end
end
