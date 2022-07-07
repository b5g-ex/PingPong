defmodule Client2 do
  use GenServer

  ### 外部 API ###
  def start_link(state \\ []) do
    {:ok, pid} = GenServer.start_link(__MODULE__, state, name: __MODULE__)
    :global.register_name(:client2, pid)
  end

  ### GenServer の実装 ###

  def init(state) do
    {:ok, state}
  end

  def handle_cast({:at_client2, [msg, cnt, loop_num, start_time]}, _current_state) do
    IO.puts("client2: #{msg} #{cnt}")
    :timer.sleep(1000)
    GenServer.cast(:global.whereis_name(:server), {:at_server_from2, [msg, cnt, loop_num, start_time]})
    {:noreply, [msg, cnt, loop_num, start_time]}
  end
end
