# AtcoderGreedy
楽にatcoderを使いたい

## Installation

    $ gem install atcoder_greedy

## Usage

```
atcoder_greedy create CONTESTNAME
```

example: ABC008の場合,下のようにファイルが生成される

```
.
├── abc008_1
│   ├── abc008_1.rb
│   ├── input.txt
│   ├── output.txt
│   └── test_abc008_1.rb
├── abc008_2
│   ├── abc008_2.rb
│   ├── input.txt
│   ├── output.txt
│   └── test_abc008_2.rb
├── abc008_3
│   ├── abc008_3.rb
│   ├── input.txt
│   ├── output.txt
│   └── test_abc008_3.rb
└── abc008_4
    ├── abc008_4.rb
    ├── input.txt
    ├── output.txt
    └── test_abc008_4.rb
```

各問題について,in.txtがインプット,out.txtがアウトプット,abc_00X_Y.rbが解答ファイル,test_abc_00X_Y.rbがテストファイルとなる。

abc00X_Y.rbのsolveメソッドに問題の解答を書く。

テストを実行するには、

```
cd abc00X_Y/
ruby test_abc00X_Y.rb
```

とすれば良い。

## 実装した機能
- サンプルインプット、アウトプットを用いたテストファイルの生成
- 解答のテンプレート生成


## TODO,実装したい機能
- リファクタリング
- テスト結果を見やすく
- 問題を指定してその問題のみ生成
- 提出機能
- 多言語もテンプレートから生成したい

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/atcoder_greedy. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

