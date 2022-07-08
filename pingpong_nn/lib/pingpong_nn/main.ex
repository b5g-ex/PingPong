defmodule Main do
  def server_start(node_name, cookie, conn_node) do
    System.cmd("epmd", ["-daemon"])
    Node.start(String.to_atom(node_name))
    Node.set_cookie(String.to_atom(cookie))
    Server.start_link()
    Node.connect(String.to_atom(conn_node))
  end

  def client_start(node_name, cookie) do
    System.cmd("epmd", ["-daemon"])
    Node.start(String.to_atom(node_name))
    Node.set_cookie(String.to_atom(cookie))
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
