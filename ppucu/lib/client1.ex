defmodule Client1 do
  use GenServer

  ### 外部 API ###
  def start_link(state \\ []) do
    {:ok, pid} = GenServer.start_link(__MODULE__, state, name: __MODULE__)
    :global.register_name(:client1, pid)
  end

  def pingpong(msg, loop_num) do
    start_time = Time.utc_now()
    # IO.puts(start_time)
    GenServer.cast(:global.whereis_name(:server), {:at_server_from1, [msg, 1, loop_num, start_time]})
  end

  ### GenServer の実装 ###

  def init(state) do
    {:ok, state}
  end

  def handle_cast({:at_client1, [msg, cnt, loop_num, start_time]}, _current_state) do
    # IO.puts("client1: #{msg} #{cnt}")
    if (cnt < loop_num) do
      # :timer.sleep(1000)
      GenServer.cast(:global.whereis_name(:server), {:at_server_from1, [msg, cnt + 1, loop_num, start_time]})
    else
      end_time = Time.utc_now()
      cal_time = Time.diff(end_time, start_time, :microsecond)
      IO.puts(cal_time)
    end
    {:noreply, [msg, cnt, loop_num, start_time]}
  end
end
