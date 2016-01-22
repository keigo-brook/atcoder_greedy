# AtcoderGreedy
楽にatcoderを使いたい. Atcoderで行われるコンテストにおいて, 自動でテンプレートやインプットを生成するGemです. 
何かありましたらtwitter: @brook_bachまでお願いします. 

## 実装した機能
- コンテストフォルダ, 問題ファイルの生成
- サンプルインプット、アウトプットを用いたテストファイルの生成, テスト実行
- ユーザーテンプレート機能
- ruby, c/c++ に対応

## Installation

    $ gem install atcoder_greedy

## 初期設定

configコマンドを使用してデフォルト言語の設定をしてください。
```
$ atcoder_greedy config
Choose default language from: ["rb", "cpp", "c"]
Input languages: cpp
Update Your default language to [cpp].
$ 
```

## Usage

### Createコマンド
コンテスト用のフォルダ, ファイルを作成します.
```
$ atcoder_greedy create CONTEST_URL OPTION
```
作成時に使用できるオプション
| option name                       | alias | detail  |
| --------------------------------- | ----- | ------- |
| --no-templates                    | --nt  | テンプレートファイルを生成しません. |
| --no-input                        | --ni  | 入力ファイルを生成しません. |
| --select-problem PROBLEM_NAMES    | -p    | 指定した問題のみ生成します. 複数の問題を指定する場合は'A B' のように''で囲ってください. |
| --select-directory DIRECTORY_PATH | -d    | 指定したディレクトリに生成します. |
| --select-language LANGUAGE        | -l    | 指定した言語でテンプレートを生成します. |
| --select-template TEMPLATE_NAME   | -t    | 指定したテンプレートで生成します. |

### testコマンド
テストを実行します. 入力ファイルが生成されている必要があります.
```
$ cd CONTESTNAME
$ atcoder_greedy test PROBLEM_FILE_NAME
```

### templateコマンド
テンプレートの設定を行います. テンプレートは複数保存でき, 言語毎に一つデフォルトテンプレートを設定することができます.
デフォルトに設定されたテンプレートは, createコマンドで作成するときに使用されます.
```
$ atcoder_greedy template OPTION
```
使用できるオプション
| option name             | alias |  detail  |
| ------------------------| ----- | -------  |
| --add FILE_PATH         | -a    | FILE_PATHで指定されたファイルをテンプレートに追加します. |
| --list                  | -l    | テンプレート一覧を表示します. |
| --set-default FILE_NAME | -s    | FILE_NAMEで指定されたテンプレートをその言語のデフォルトに設定します. |
| --delete FILE_NAME      | -d    | FILE_NAMEで指定されたテンプレートを削除します. |

## 使用例
ABC009の場合

```
$ atcoder_greedy create abc009
```

とすると、以下のようなファイルが生成される。

```
.
├── A.rb
├── B.rb
├── C.rb
├── D.rb
├── input_A.txt
├── input_B.txt
├── input_C.txt
└── input_D.txt
```

各問題について,X.rbに自分の解答を記述すれば良い。
input_X.txtにはX.rbのサンプルインプット，アウトプットが記載されている.

A問題についてテストを実行するには、

```
$ atcoder_greedy test A.rb
```

とすると、以下のようにテスト結果が表示される。

```
Running a test for problem A.rb...
-------------------- Compile Done --------------------
-------------------- Testcase #0 -------------------- FAILED! Time: 0.00727s
Your Output:
5
Correct Answer:
1

-------------------- Testcase #1 -------------------- PASSED! Time: 0.04882s

-------------------- Testcase #2 -------------------- FAILED! Time: 0.00614s
Your Output:
3
Correct Answer:
1

Test done.
```

## TODO,実装したい機能

- 提出機能
- 言語対応の拡大
- gemのテスト作成

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/atcoder_greedy. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.
## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

