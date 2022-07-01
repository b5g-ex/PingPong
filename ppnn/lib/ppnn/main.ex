defmodule Main do
  def server_start do
    Server.start_link()
  end

  def client_start do
    Client.start_link()
  end

  def client_timer(msg, loop_num, time_cnt \\ 1) do
    if (time_cnt <= 100) do
      Client.pingpong(msg, loop_num)
      :timer.sleep(1000)
      client_timer(msg, loop_num, time_cnt + 1)
    end
  end
end
