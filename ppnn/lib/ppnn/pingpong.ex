# サーバプロセスのモジュール
defmodule PingPong do
  def server_start do
    pid = spawn(__MODULE__, :loop, []) # PingPong.loop()プロセスを生成
    :global.register_name(:server, pid) # このサーバープロセスのPIDを:serverという名前で登録する
  end

  def loop do
    # クライアントプロセスからのメッセージを受信する
    receive do
      {sender, msg} ->
        #IO.puts("#{__MODULE__}: received message: #{msg}")
        # クライアントプロセスへメッセージを送信する
        send sender, {:ok, "#{msg}"}
        #IO.puts("#{__MODULE__}: sent message: #{msg}")
    end
    loop
  end
end

# クライアントプロセスのモジュール
defmodule Client do
  def start(max_cnt, pack) do
    cnt = 1 # 今何回やりとりしたかのカウント値
    # サーバプロセスへメッセージを送信する
    send :global.whereis_name(:server), {self, "#{pack}"}
    #IO.puts("#{__MODULE__}: sent message: #{pack} ##{cnt}")
    # サーバプロセスからメッセージを受信する
    receive do
      {:ok, msg} ->
        #IO.puts("#{__MODULE__}: received message: #{msg} ##{cnt}")
        client_loop(cnt + 1, max_cnt, msg)
    end
  end

  # max_cnt 回 PingPong を繰り返す
  def client_loop(cnt, max_cnt, msg) do
    send :global.whereis_name(:server), {self, "#{msg}"}
    #IO.puts("#{__MODULE__}: sent message: #{msg} ##{cnt}")
    receive do
      {:ok, message} ->
        #IO.puts("#{__MODULE__}: received message: #{message} ##{cnt}")
        if cnt < max_cnt do
          client_loop(cnt + 1, max_cnt, message)
        end
    end
  end

  # pack のやりとりを max_cnt 回行ったときにかかる時間の10回平均を計測する
  def time_measurement(max_cnt, pack, time_cnt \\ 1, a \\ []) do
    if time_cnt <= 10 do
      {t, nil} = :timer.tc(Client, :start, [max_cnt, pack])
      Enum.into([t], a)
      IO.puts("time: #{t}")
      time_measurement(max_cnt, pack, time_cnt + 1, [t | a])
    end
    if time_cnt == 10 do
      ave = Statistics.mean(a) # 平均
      std = Statistics.stdev(a) # 標準偏差
      IO.puts("Average: #{ave}")
      IO.puts("Std: #{std}")
    end
  end
end
