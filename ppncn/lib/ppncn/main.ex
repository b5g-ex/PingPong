defmodule Main do
  # def server_start do
  #   System.cmd("epmd", ["-daemon"])
  #   System.get_env("NODE_NAME_S")
  #   |> String.to_atom
  #   |> Node.start
  #   System.get_env("COOKIE")
  #   |> String.to_atom
  #   |> Node.set_cookie
  #   Server.start_link()
  # end

  # def client1_start do
  #   System.cmd("epmd", ["-daemon"])
  #   System.get_env("NODE_NAME_C1")
  #   |> String.to_atom
  #   |> Node.start
  #   System.get_env("COOKIE")
  #   |> String.to_atom
  #   |> Node.set_cookie
  #   # Client1.start_link()
  #   System.get_env("CONNECT_TARGET")
  #   |> String.to_atom
  #   |> Node.connect
  # end

  # def client2_start do
  #   System.cmd("epmd", ["-daemon"])
  #   System.get_env("NODE_NAME_C2")
  #   |> String.to_atom
  #   |> Node.start
  #   System.get_env("COOKIE")
  #   |> String.to_atom
  #   |> Node.set_cookie
  #   Client2.start_link()
  #   System.get_env("CONNECT_TARGET")
  #   |> String.to_atom
  #   |> Node.connect
  # end

  def client_timer(msg, loop_num, time_cnt \\ 1) do
    if (time_cnt <= 50) do
      Client1.pingpong(msg, loop_num)
      :timer.sleep(2000)
      client_timer(msg, loop_num, time_cnt + 1)
    end
  end
end
