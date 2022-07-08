# PingpongNcn

## Description

Node1(Nerves) -> Cloud -> Node2(Nerves) -> Cloud -> Node1 -> ...の通信時間を計測できます．Node1，Node2 のいずれかが Ubuntu であっても構いません．

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
  * ファームウェアを作るために `mix firmware` を実行します．
  * `mix firmware.burn` により，ファームウェアを SD カードに焼きます．また，既に SD カードに焼いている場合は，`mix upload nerves.local` により，遠隔で SD カードの中身を書き換えられます．
  * `ssh nerves.local` により，ハードウェアターゲットに ssh 接続します．すると，Nerves が立ち上がります．
2つのハードウェアとクラウドの計3つのターミナルでのコマンドを紹介します．
  * ハードウェア1：
    * `Main.client1_start("node_name", "cookie", "connect_node")` により，`node_name` という名前のノードを開始し，cookie を `cookie` により設定し，クライアント1の GenServer を立ち上げると共に，`connect_node` に対して Node.connect します．
    * クラウドのノード開始，GenServer 開始後にこのコマンドを打ってください．
    * 3ノード全ての GenServer が立ち上がったら，`Main.client_timer("message", loop_number)` により，通信時間の計測を始めることができます．`message` はやりとりする文章，`loop_number` はやりとりする回数を指定します．
  * ハードウェア2：
    * ハードウェア1と同様です．
  * クラウド：
    * `iex --name node_name --cookie cookie -S mix` により，`node_name` というノードを開始します．
    * `Main.server_start` により，クラウドの GenServer を開始します．
注意点：
  * 3ノードの cookie は全て同じにしてください．そうでないと，Node.connect に失敗します．

## Learn more

  * Official docs: https://hexdocs.pm/nerves/getting-started.html
  * Official website: https://nerves-project.org/
  * Forum: https://elixirforum.com/c/nerves-forum
  * Discussion Slack elixir-lang #nerves ([Invite](https://elixir-slackin.herokuapp.com/))
  * Source: https://github.com/nerves-project/nerves
