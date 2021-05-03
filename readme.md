# simplcidパッケージ

(u)pLaTeX2eにおいては，AdobeJapan1-7の文字セットにアクセスする手段としてotfパッケージが事実上の標準です．しかし，otfパッケージは，norepalceオプションを有効にしなければ，クラスファイルで指定されたjfmファイルをotfパッケージ独自のものに置き換えて組版するという特徴があります．実際のところはotfパッケージが提供するjfmファイルの方がいろいろと都合がよいのですが，商業的な組版においてはotfパッケージを不用意に追加してしまうと想定していない結果となり大きな問題になります．

また，otfパッケージにはAdobeJapan1-7の文字を多書体で使用できるdeluxeオプションも存在しますが，多書体を想定して作成されてはいるがotfパッケージを考慮していない既存のクラスファイルと組み合わせるのはそう簡単なことではありません．

さらに，deluxeオプションが想定している書体数よりも多くの書体でAdobeJapan1-7の文字が要求される状況下ではotfパッケージをそのまま使うことはできません．このような場合otfパッケージに付随するtfmファイルやvfファイルと同等なものを構成して，otfパッケージの内容を拡張するのが正当な解決法なのでしょうが，otfパッケージそのものの性能の高さがそのような模倣をとても難しいものとしています．

そもそもクラスファイル作成時にotfパッケージを使用するか否かを考慮して，使用するならばotfパッケージをクラスファイル内で読み込んでそれを前提としてクラスファイルを作るのが本筋なのでしょう．あとからotfパッケージを読み込むことには大きなリスクが伴います．しかし，人名などでどうしてもあとから文字が必要になる場合，丸数字などが必要になる場合，それも見出しなど目立つ部分で必要になることが往々にしてあります．

どうにもならない場合は文字を画像として作成してそれを貼りこむという「読めればよい」レベルでの解決がなされてきましたが，そもそもその文字を収録しているフォントが存在するのに画像として貼りこむのは本末転倒です．そこで，たくさんの書体でのJIS0208に存在しない文字の要求やotfパッケージを想定していない状況でのJIS0208範囲外の文字の要求を解決するための手段として，以下の条件を満たす「simplecidパッケージ」を公開します．

- CIDで文字を指定できる，otfパッケージの\CIDに相当する，\sCIDを提供する
    - 周囲の書体と文字サイズに追随させる（クラスファイルの設定によるがたいていの場合は問題ない）
    - クラスファイルで指定されているjfmを置き換えない（本パッケージマクロの読み込みの有無だけでは組版結果が変わらない）
- 本文の明朝体・ゴシック体に加えて20書体まで（合計22書体）の多書体化に対応（多少の変更で追加可能）

## 動作環境

- pLaTeX2e（TeXLive2017 frozen or later）（upLaTeX2eは非対応）
- dvipdfmx

simplecidパッケージの実装にはexpl3を用いています．実装で用いられているexpl3の機能で一番新しいものはregexモジュールの`\regex_replace_all:nnN`です．また，付随するjfm/vfはJIS符号化に依存しますので，simplecidパッケージは2017年以降のexpl3が動作するバージョンのpLaTeX2e専用です．upLaTeX2eでは動作しません．JISではなくutf8に沿うようなtfm/vfファイルを作成すればupLaTeX2eに対応するできるとは思いますが，それは今後の課題とします．

現状ではドライバはdvipdfmxのみに対応してます．多少の手作業でmapファイルを書き換えて，パッケージオプションを適切にすればdvipsでも動作はするはずですがテストはしていません．

また，otfパッケージと同様にAJ1であるCIDフォントを想定しています．AI0であるフォントは考慮していません．


## ファイルの構成とインストール

simplecidパッケージは以下のファイルからなります．

    simplecid.sty：パッケージの本体
    scid-prop.dat：CIDへのエイリアスを定めるproperty list
    tfm --- scidmin-00.tfm--scidmin-03.tfm
            scidgoth-00.tfm--scidgoth-03.tfm
            scid00-01.tfm--scid00-03.tfm 
            scid01-01.tfm--scid01-03.tfm
            ...
            scid19-01.tfm--scid19-03.tfm     ：組版に用いるtfmファイル群（88ファイル）
            scidmin-raw.tfm, scidgoth-raw.tfm
            scid00-raw.tfm～scid19-raw.tfm   ：vfから呼ばれるファイルtfm群（22ファイル）
    vf  --- scidmin-00.vf--scidmin-03.vf
            scidgoth-00.vf--scidgoth-03.vf
            scid00-01.vf--scid00-03.vf 
            scid01-01.vf--scid01-03.vf
            ...
            scid19-01.vf--scid19-03.vf       ：vfファイル群（88ファイル）

インストールは，``simplecid.sty`と`scid-prop.dat`は`$texmf(-local)/tex/latex/simplecid`へ，tfmファイルは`$texmf(-local)/fonts/tfm/simplecid`へ，vfファイルは`$texmf(-local)/fonts/vf/simplecid`へコピーして，必要に応じて`mktexlsr`で`ls-R`を更新してください．もしくはカレントディレクトリにすべてをコピーすれば使えます．


## \usepakageの書式

    \usepackage[<options>]{simplecid}
       <options>     := <option>*
       <option>      := <generateMap>|<embedMap>|<mapname>
       <generateMap> := generateMap(\s*=\s*(<true>|<false>))?
       <embdeMap>    := embedMap(\s*=\s*(<true>|<false>))?
       <mapname>     := mapname(\s*=\s*<mapfile>)?

       <true>        := true 
       <false>       := false 
       <mapfile>     := 任意のファイル名


`\usepackage`に与えることのできるオプションは<key>=<val>形式です．

- generateMap 
  `generateMap=true`ではsimplecidパッケージが必要とするmapファイルを自動生成します．`generateMap=false`の場合は生成しません．値を省略してgenerateMapだけとした場合はtrueが指定されたとみなされます．デフォルトはgenerateMap=trueです．
- embedMap 
  `embedeMap=true`ではsimplecidパッケージが必要とするmapファイル名をdviファイルに埋め込みます．`embedMap=false`の場合は埋め込みません．値を省略してembedMapだけとした場合はtrueが指定されたとみなされます．埋め込まれるmapファイルのファイル名はmapnameオプションで指定されるものです．デフォルトは`embedMap=true`です．
- mapfile
  simplecidパッケージが生成する（そして埋め込むことを指定できる）mapファイルのファイル名を指定します．`mapfile=hoge.map`で，`generateMap=true`の場合にhoge.mapが生成され，`embedMap=true`の場合に`hoge.map`が埋め込まれます．ファイル名を指定しなかった場合は，`scidfonts-`<driver>`.map`となります．実際のところは`scidfonts-dvipdfmx.map`になります．

## 提供されるコマンド

### `\sCID`

    \sCID{<cid number>}

引数にCID番号<cid number>を指定することで，そのCID番号の文字を日本語として出力します．そのCID番号の文字が従属欧文のグリフであろうとも，約物であろうとも常に和文として扱います．このようにすることでtfmの構造をシンプルにして「ただ貼りこむ」を実現します．日本語として扱うようにしているので，ソース内で`\sCID{1234}`のように用いた直後に改行しても空白は入りません．使用される書体やサイズはそこで指定されているものになります．

### `\sCIDSym`

    \sCIDsym{<symbol name>}

引数に<symbol name>なる「記号の名前」を与えることで当該の記号を和文として出力します．現状（2021/05/03 1.0beta）では以下のものを「記号の名前」として使用できます．

- 丸（丸囲みの数字や文字）
- 丸丸（二十丸囲みの数字）
- 黒丸（黒丸に数字や文字）
- 黒角（黒四角に数字や文字）
- 角（四角囲みの数字や文字）
- 丸角（角丸の四角囲みの数字や文字）
- 黒丸角（角丸の黒四角に数字や文字）
- ()（カッコつきの数字や文字）

具体的には`\sCIDsym{丸上}`とすれば「○の中に上」の文字を表しますし，`\sCIDSym{(9)}`は「(9)の組文字」です．otfパッケージに付随する`ajmacros.sty`では数字で指定していましたが，それを「文字」で指定するようにしています．使用される書体やサイズはそこで指定されているものになります．どのような記号が使えるかはAdobeJapan1-7の文字一覧を参照してください．

### `\sCIDSym`の別名

`\sCIDsym`には以下のような別名を用意しています．

#### `\sCIDMaru`

`\sCIDMaru{<hoge>}`は`\sCIDSym{丸<hoge>}`です．

#### `\sCIDNizyuMaru`

`\sCIDNizyuMaru{<hoge>}`は`\sCIDSym{丸丸<hoge>}`です．

#### `\sCIDKuroMaru`

`\sCIDKuroMaru{<hoge>}`は`\sCIDSym{黒丸<hoge>}`です．

#### `\sCIDKuroKaku`

`\sCIDKuroKaku{<hoge>}`は`\sCIDSym{黒角<hoge>}`です．

#### `\sCIDKaku`

`\sCIDKaku{<hoge>}`は`\sCIDSym{角<hoge>}`です．

#### `\sCIDMaruKaku`

`\sCIDMaruKaku{<hoge>}`は`\sCIDSym{丸角<hoge>}`です．

#### `\sCIDKuroMaruKaku`

`\sCIDKuroMarukaku{<hoge>}`は`\sCIDSym{黒丸角<hoge>}`です．

#### `\sCIDKakko`

`\sCIDKakko{<hoge>}`は`\sCIDSym{(<hoge>)}`です．

