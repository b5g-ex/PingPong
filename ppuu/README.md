# Ppuu

## Description

Node1 -> Node2 -> Node1 -> ... もしくは Node1 -> Cloud -> Node1 -> ...の通信時間を計測できます．このプロジェクトは，Node1, 2に Ubuntu を適用する場合のものです．Cloud は常に Ubuntu 上で動かします．Node1 と Node2 の OS が異なっていても問題ありません．

## Environmental Variables

使用する環境変数は，`CONNECT_TARGET` のみです．
  * `CONNECT_TARGET` には  サーバーが `Node.connect` する相手のノード名を設定します．

## Getting Started

Ubuntu のターミナル上でコマンドを打ちます．
  * 環境変数を `export` により設定します．
  * 依存関係をインストールするために `mix deps.get` を実行します．
  * `mix compile` により，プロジェクトをコンパイルします．
  
サーバー・クライアントでのコマンドを紹介します．
  * サーバー：
    * `iex --name node_name --cookie cookie -S mix` により，`node_name` というノードを開始します．
    * `Main.server_start` により，サーバーの GenServer を立ち上げると共に，`CONNECT_TARGET` に対して `Node.connect` します．
  * クライアント：
    * `iex --name node_name --cookie cookie -S mix` により，`node_name` というノードを開始します．
    * `Main.client_start` により，クライアントの GenServer を立ち上げます．
    * ノード全ての GenServer が立ち上がったら，`Main.client_timer("message", loop_number)` により，通信時間の計測を始めることができます．`message` はやりとりする文章，`loop_number` はやりとりする回数を指定します．

注意点：
  * 3ノードの cookie は全て同じにしてください．そうでないと，Node.connect に失敗します．
