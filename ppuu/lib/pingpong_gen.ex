defmodule PingpongGen do
  use GenServer

  def server_start(msg \\ "", cnt \\ 0) do
    {:ok, pid} = GenServer.start(__MODULE__, {msg, cnt})
    :global.register_name(:server, pid)
  end

  def init(state) do
    {:ok, state}
  end

  def handle_call(:pingpong, _from, {msg, cnt}) do
    {:reply, {msg, cnt}, {msg, cnt + 1}}
  end

  def handle_cast({:receive, {msg, cnt}}, {_pre_msg, _pre_cnt}) do
    {:noreply, {msg, cnt}}
  end

  def client_start(msg, loop_num, cnt \\ 1, a \\ []) do
    if (cnt <= 100) do
      {t, nil} = :timer.tc(__MODULE__, :loop, [msg, loop_num])
      IO.puts(t)
      client_start(msg, loop_num, cnt + 1, [t | a])
    else
      IO.puts("Average: ")
      a |> Statistics.mean |> IO.inspect
      IO.puts("Standard Dev: ")
      a |> Statistics.stdev |> IO.inspect
    end
  end

  def loop(msg, loop_num) do
    GenServer.cast(:global.whereis_name(:server), {:receive, {"#{msg}", 1}})
    do_loop(loop_num)
  end

  defp do_loop(loop_num) do
    {_msg, cnt} = GenServer.call(:global.whereis_name(:server), :pingpong)
    if (cnt < loop_num) do
      do_loop(loop_num)
    end
  end
end
