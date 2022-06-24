### サーバプロセスのモジュール ###

defmodule PingPong do

  ## サーバプロセスを開始する関数 ##
  def server_start do
    pid = spawn(__MODULE__, :loop, []) # PingPong.loop()プロセスを生成
    :global.register_name(:server, pid) # このサーバープロセスのPIDを:serverという名前でグローバルに登録する
  end

  ## PingPong通信のためのループ関数 ##
  def loop do
    # クライアントプロセスのPID(sender)と送られてきたメッセージ(msg)を受信する
    receive do
      {sender, msg} ->
        send sender, {:ok, "#{msg}"} # クライアントプロセスへmsgを送り返す
    end
    loop # 再帰
  end
end



### クライアントプロセスのモジュール ###

defmodule Client do

  ## クライアントプロセスを開始する関数 ##
  # 入力...loop_num: PingPong送信回数，pkg: やりとりするパッケージ
  def start(loop_num, pkg) do
    send :global.whereis_name(:server), {self, "#{pkg}"} # サーバープロセスへpkgを送信する
    loop(1, loop_num) # ループ開始
  end

  ## PingPong通信のためのループ関数 ##
  # 入力...cnt: 何ループ目かを表すカウント値，loop_num: PingPong送信回数
  def loop(cnt, loop_num) do
    # サーバープロセスから送られてきたメッセージ(msg)を受信する
    receive do
      {:ok, msg} ->
        # loop_num回繰り返す
        if cnt < loop_num do
          send :global.whereis_name(:server), {self, "#{msg}"} # サーバープロセスへmsgを送り返す
          loop(cnt + 1, loop_num) # 再帰
        end
    end
  end

  ## PingPong通信にかかる時間を計測する関数 ##
  # 入力...loop_num: PingPong送信回数，pkg: やりとりするパッケージ，cnt: 何回目の計算かを表すカウント値，a: 計算時間を格納するリスト
  def time_mm(loop_num, pkg, cnt \\ 1, a \\ []) do
    # 100回繰り返す
    if cnt <= 100 do
      {t, nil} = :timer.tc(__MODULE__, :start, [loop_num, pkg]) # 時間計測
      IO.puts(t)
      time_mm(loop_num, pkg, cnt + 1, [t | a]) # 再帰
    else
      IO.puts("Average: ")
      a |> Statistics.mean |> IO.inspect # 計測時間の平均
      IO.puts("Standard Dev: ")
      a |> Statistics.stdev |> IO.inspect # 計測時間の標準偏差
    end
  end
end
