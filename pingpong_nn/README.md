# Ppnn

## Description

Node1 -> Node2 -> Node1 -> ... もしくは Node1 -> Cloud -> Node1 -> ...の通信時間を計測できます．このプロジェクトは，Node1, 2に Nerves を適用する場合のものです．Cloud は常に Ubuntu 上で動かすため，Cloud の設定については，pp_uu の README を参照してください．
Node1 と Node2 の OS が異なっていても問題ありません．

## Environmental Variables

使用する環境変数は，`MIX_TARGET`，`WIFI_SSID`，`WIFI_PSK`，`RP4_ETH`，`HOST_NAME` の5つです．
  * `MIX_TARGET` には使用するハードウェアターゲットを設定します（例：`rpi4`）．`MIX_TARGET` が設定されていない場合，`mix` は host 上で実行されるイメージを構築します．ターゲットは https://hexdocs.pm/nerves/targets.html#content から記法がわかります．
  * `WIFI_SSID` と `WIFI_PSK` には，それぞれハードウェアターゲットの使用している Wi-Fi の SSID と パスワードを設定します．これにより，`mix upload` によるコードの更新を行うことができるようになります．
  * `PR4_ETH` には，ハードウェアターゲットの `eth0` の IP アドレスを設定します．
  * `HOST_NAME` により，`ssh nerves.local` の `nerves` 部分の名前を自由に決めることができます．これにより，2つ以上のハードウェアを用いたときに,`mix upload` や `ssh nerves.local` での交錯を防ぐことができます．

## Getting Started

PC のターミナル上でコマンドを打ちます．
  * 環境変数を `export` により設定します．
  * 依存関係をインストールするために `mix deps.get` を実行します．
  * ファームウェアを作成するために `mix firmware` を実行します．
  * `mix firmware.burn` により，ファームウェアを SD カードに焼きます．また，既に SD カードに焼いてハードウェアに SD カードを差し込んでいる場合は，`mix upload HOST_NAME.local` により，遠隔で SD カードの中身を書き換えられます．
  * `ssh nerves.local` により，ハードウェアターゲットに ssh 接続します．すると，Nerves が立ち上がります．
  
サーバー・クライアントでのコマンドを紹介します．
  * サーバー：
    * `Main.server_start("node_name", "cookie", "conn_node")` により，`node_name` という名前のノードを開始し，cookie を `cookie` により設定し，サーバーの GenServer を立ち上げると共に，`conn_node` に対して `Node.connect` します．この `conn_node` は，クライアントのノード名です．
  * クライアント：
    * `Main.client_start("node_name", "cookie", "conn_node")` により，`node_name` という名前のノードを開始し，cookie を `cookie` により設定し，クライアントの GenServer を立ち上げます．
    * ノード全ての GenServer が立ち上がったら，`Main.client_timer("message", loop_number)` により，通信時間の計測を始めることができます．`message` はやりとりする文章，`loop_number` はやりとりする回数を指定します．
    
注意点：
  * 2ノードの cookie は全て同じにしてください．そうでないと，Node.connect に失敗します．

## Learn more

  * Official docs: https://hexdocs.pm/nerves/getting-started.html
  * Official website: https://nerves-project.org/
  * Forum: https://elixirforum.com/c/nerves-forum
  * Discussion Slack elixir-lang #nerves ([Invite](https://elixir-slackin.herokuapp.com/))
  * Source: https://github.com/nerves-project/nerves
