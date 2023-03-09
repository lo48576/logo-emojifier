# Logo Emojifier

## なにこれ？

アニメやゲーム、ブランド等のロゴの文字をカスタム絵文字 (Custom Emojis) 化するためのスクリプト群。

## どうやって？

1. スクリプトを実行して、元となるロゴ画像のファイルをダウンロードする。
2. スクリプトを実行して、ダウンロードしてきた画像から切り抜きや加工を行い、カスタム絵文字画像を出力する。
3. カスタム絵文字を利用可能なところで使う。

### コマンド

#### 全処理
```
$ helpers/gen-all.sh
```

`_downloaded/` 以下に素材となるファイルをダウンロードし、 `_generated/` 以下にカスタム絵文字ファイルを生成する。

これだけ実行すればカスタム絵文字ファイルが得られる。

#### ダウンロード
```
$ helpers/dl.sh path/to/asset.conf
```

`_downloaded/` 以下に、素材となるファイルをダウンロードする。

#### 画像加工
```
$ helpers/dl.sh path/to/asset.conf
```

`_generated/` 以下に、カスタム絵文字ファイルを生成する。

### 依存
* 基本的な POSIX コマンド群
    + スクリプトの記述や実行に用いる。
    + `sh`, `sed`, `nproc`, `find`, `xargs`, `dirname`, `readlink`, `sha512sum` 等。
* `envsubst` コマンド (`gettext` パッケージの一部)
    + 画像の加工スクリプトの実行に用いる。
* `curl`
    + 画像のダウンロードに用いる。
* `imagemagick` (バージョン 7 以降)
    + 画像の加工に用いる。
* `oxipng`
    + 生成された PNG ファイルのサイズを無劣化で最適化するのに用いる。

## なぜ？

### なぜスクリプト？
権利関係の問題を回避しつつカスタム絵文字を共有するため。

日本ではフェアユースが認められておらず、加工済画像を直接再頒布することは著作権侵害になる。
そのため、画像の入手方法と加工方法をスクリプトの形で実行可能な手順として公開し、これを各ユーザが自分のために実行するという形をとる。
手順自体は加工対象の画像による権利制限を受けないため、自由に入手・改造・再頒布が可能となる。

## どうなの？

### 生成された画像の権利は？
日本では、引き続き、元画像の権利者が持っているはず。
当リポジトリのスクリプトは権利を「剥がす」のには使えない。

### AGPL こわいんだけど？
1行まとめ: 自分の手元でのみ使う分には、気にするようなことは特にない。

* 生成された画像や、それを利用するプログラムには、当リポジトリの AGPL の効力は及ばない。
* スクリプトを他人に渡したりリモート実行させるような場合には影響があるが、手元でただ実行するだけなら基本的には何も心配はない。
* 画像の加工スクリプトを書くのは面倒なので、タダ乗りせずに利用者にスクリプトを提供しましょう、ということ。
    + たとえば以下のような場合 (ただしこれに限らない) に、あなたは対象のスクリプトや組み込み先のプログラムを利用者に公開する義務を負います。
        - 別の場所でスクリプトを再頒布したり
        - 自作プログラムにスクリプトを組み込んだり
        - スクリプトを利用した web サービスを公開したり
    + もし改変したスクリプトを実行しているなら、改変した版を公開する必要があります。
        - 他人の成果に乗るなら、自分の成果も還元しましょうということ。

(これは法的に効力のあるアドバイスではありません。)

### プルリク採用の基準は？
独断と気まぐれ。
配色や形状等に強い特徴があって、1〜2文字見るだけで「あの作品かぁ」と思えるようなものは採用しやすい。
逆に、常識的すぎてただフォントを画像化しただけの状態に近いものは不採用になりやすい。

### 画像加工スクリプトを追加するときの手順と注意は？
1. `assets/` 以下の適切な位置に、作品用のディレクトリを作る。
    + 他のディレクトリがどうなっているか観察して、命名や階層を適宜合わせる。
2. 作品用のディレクトリ内に、4つのファイルを配置する。
    + `asset.conf`
        - ファイル先頭に付ける文字列を `PREFIX` をシェル形式 (dotenv 形式) で指定。
    + `curl-download.conf`
        - curl の config 形式で、ファイルのダウンロード方法を記述。
        - 保存先のファイル名は `タイトル.横x縦.拡張子` のようにする。
          たとえば `けものフレンズ2.1920x1041.png` 等。
        - curl(1) を参照。
    + `downloads.sha512sum`
        - ダウンロードされたファイルについて `sha512sum --binary *`
          を実行したときの出力を保存したファイル。
        - sha512sum(1) を参照。
    + `filter.mgk.template`
        - imagemagick のスクリプト形式で、画像の加工方法を指定する。
        - ただしファイルを `-write` するとき、 ${DEST_PREFIX} を使うことができる。
        - magick-script(1) を参照。
        - これが当リポジトリで一番重要で、一番作るのが面倒なもの。
        - メンテナンスできない場合、作り直しや削除となる可能性があるので、コメントをしっかり書くこと。
3. ひととおり実行してみて所望の結果が得られることを確認する。
    + 所望の結果を得られなければ、修正の必要がある。
4. 提出する。

### エラーが出たけど？
エラーメッセージやログを読むこと。

* コマンドが足りてなさそうな場合:
    + インストールする。
* ダウンロードが失敗していそうな場合:
    + サーバやネットワークの状態が改善するまで待つ。
    + ファイルが削除されていた場合、ダウンロードする URI を web archive
      のものに切り替えるか、加工スクリプトを書き直す。
* 画像のチェックサムが不一致の場合、または画像のサイズ (dimensions) がおかしそうな場合:
    + 加工スクリプトが書かれた後で、リモートかローカルの素材ファイルが変更されてしまった可能性が高い。
    + ローカルのダウンロード済ファイルを削除して再度ダウンロードを試みる。
        - これで問題がなくなれば、ひとまずは使い物になる。
    + 再度ダウンロードしても症状が変化しない場合、ダウンロードする URI を web archive
      のものに切り替えるか、加工スクリプトを書き直す。

## 許諾・免責

当リポジトリのスクリプト群は GNU Affero General Public License v3.0 or later のもとで公開される。

### 貢献
スクリプトの改善や追加、修正などの貢献を歓迎します。
ただし、当リポジトリは AGPL v3.0 またはそれ以降のバージョンでライセンスされたファイルのみを受け入れます。

AGPL v3.0 で配布する権利を持っていないようなファイルや変更は導入しないでください。
たとえば典型的には、 all rights reserved な画像ファイルをコミットしないでください。
