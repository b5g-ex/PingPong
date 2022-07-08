defmodule Main do
  def server_start do
    Server.start_link()
  end

  def client1_start(node_name, cookie, conn_node) do
    System.cmd("epmd", ["-daemon"])
    Node.start(String.to_atom(node_name))
    Node.set_cookie(String.to_atom(cookie))
    Client1.start_link()
    Node.connect(String.to_atom(conn_node))
  end

  def client2_start(node_name, cookie, conn_node) do
    System.cmd("epmd", ["-daemon"])
    Node.start(String.to_atom(node_name))
    Node.set_cookie(String.to_atom(cookie))
    Client2.start_link()
    Node.connect(String.to_atom(conn_node))
  end

  def client_timer(msg, loop_num, time_cnt \\ 1) do
    if (time_cnt <= 50) do
      Client1.pingpong(msg, loop_num)
      :timer.sleep(2000)
      client_timer(msg, loop_num, time_cnt + 1)
    end
  end
end
