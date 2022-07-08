# Ppucu

## Description

Node1 -> Cloud -> Node2 -> Cloud -> Node1 -> ...の通信時間を計測できます．このプロジェクトは，Node1, 2に Ubuntu を適用する場合のものです．Cloud は常に Ubuntu 上で動かします．
Node1 と Node2 の OS が異なっていても問題ありません．

## Environmental Variables

使用する環境変数は，`CONNECT_TARGET1`，`CONNECT_TARGET2` の2つです．
  * `CONNECT_TARGET1` には Node1 が `Node.connect` する相手のノード名を設定します．今回の場合は，クラウドのノード名です．
  * `CONNECT_TARGET2` には Node2 が `Node.connect` する相手のノード名を設定します．今回の場合は，クラウドのノード名です．

## Getting Started

Ubuntu のターミナル上でコマンドを打ちます．
  * 環境変数を `export` により設定します．
  * 依存関係をインストールするために `mix deps.get` を実行します．
  * `mix compile` により，プロジェクトをコンパイルします．
  
2つのハードウェアとクラウドの計3つのターミナルでのコマンドを紹介します．
  * ハードウェア1：
    * `iex --name node_name --cookie cookie -S mix` により，`node_name` というノードを開始します．
    * `Main.client1_start` により，クライアント1の GenServer を立ち上げると共に，`CONNECT_TARGET1` に対して `Node.connect` します．
    * 3ノード全ての GenServer が立ち上がったら，`Main.client_timer("message", loop_number)` により，通信時間の計測を始めることができます．`message` はやりとりする文章，`loop_number` はやりとりする回数を指定します．
  * ハードウェア2：
    * `iex --name node_name --cookie cookie -S mix` により，`node_name` というノードを開始します．
    * `Main.client2_start` により，クライアント2の GenServer を立ち上げると共に，`CONNECT_TARGET2` に対して `Node.connect` します．
  * クラウド：
    * `iex --name node_name --cookie cookie -S mix` により，`node_name` というノードを開始します．
    * `Main.server_start` により，クラウドの GenServer を開始します．
注意点：
  * 3ノードの cookie は全て同じにしてください．そうでないと，Node.connect に失敗します．
