# atcoder_greedy
楽にatcoderを使いたい
## 使い方
コンテストのトップURLを引数にして実行

example: ABC008の場合
```
ruby start.rb http://abc008.contest.atcoder.jp
```

こんな感じになる

```
├── LICENSE
├── README.md
├── abc008
│   ├── abc008_1
│   │   ├── abc008_1.rb
│   │   ├── in.txt
│   │   ├── out.txt
│   │   └── test_abc008_1.rb
│   ├── abc008_2
│   │   ├── abc008_2.rb
│   │   ├── in.txt
│   │   ├── out.txt
│   │   └── test_abc008_2.rb
│   ├── abc008_3
│   │   ├── abc008_3.rb
│   │   ├── in.txt
│   │   ├── out.txt
│   │   └── test_abc008_3.rb
│   └── abc008_4
│       ├── abc008_4.rb
│       ├── in.txt
│       ├── out.txt
│       └── test_abc008_4.rb
└── start.rb
```

各問題について,in.txtがインプット,out.txtがアウトプット,abc_00X_Y.rbが解答ファイル,test_abc_00X_Y.rbがテストファイルとなる。

abc00X_Y.rbのsolveメソッドに問題の解答を書く。

テストを実行するには、

```
ruby test_abc00X_Y.rb
```

とすれば良い。


## 実装した機能
- サンプルインプット、アウトプットを用いたテストファイルの生成
- 解答のテンプレート生成

## TODO,実装したい機能
- リファクタリング
- テスト結果を見やすく
- gem化
- 問題を指定してその問題のみ生成
- 提出機能
- 多言語もテンプレートから生成したい
