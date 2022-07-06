defmodule Main do
  def server_start do
    Server.start_link()
  end

  def client1_start do
    Client1.start_link()
    System.get_env("CONNECT_TARGET1")
    |> String.to_atom
    |> Node.connect
  end

  def client2_start do
    Client2.start_link()
    System.get_env("CONNECT_TARGET2")
    |> String.to_atom
    |> Node.connect
  end

  def server_timer(msg, loop_num, time_cnt \\ 1) do
    if (time_cnt <= 50) do
      Server.pingpong(msg, loop_num)
      :timer.sleep(2000)
      server_timer(msg, loop_num, time_cnt + 1)
    end
  end
end
