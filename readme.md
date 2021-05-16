# simplcidパッケージ

(u)pLaTeX2eにおいては，AdobeJapan1-7の文字セットにアクセスする手段としてotfパッケージが事実上の標準です．ところが，otfパッケージには，norepalceオプションを指定しなければ，クラスファイルで指定されたjfmファイルをotfパッケージ独自のものに置き換えて組版するという特徴があります．実際のところはotfパッケージが提供するjfmファイルの方がいろいろと都合がよいのですが，商業的な組版においてはotfパッケージを不用意に追加してしまうと想定していない結果となり大きな問題になります．
また，otfパッケージにはAdobeJapan1-7の文字を多書体で使用できるdeluxeオプションも存在しますが，多書体を想定して作成されてはいるがotfパッケージを考慮していない既存のクラスファイルと組み合わせることはそう簡単なことではありません．

さらに，deluxeオプションが想定している書体数よりも多くの書体でAdobeJapan1-7の文字が要求される状況においてはotfパッケージをそのまま使うことはできません．このような場合otfパッケージに付随するtfmファイルやvfファイルと同等のものを構成して，otfパッケージを拡張するのが正当な解決法なのでしょうが，otfパッケージそのものの性能の高さがそのような模倣をとても難しいものとしています．

そもそもクラスファイル作成時にotfパッケージを使用するか否かを考慮して，使用するならばotfパッケージをクラスファイル内で読み込んでそれを前提としてクラスファイルを作るのが本筋なのでしょう．あとからotfパッケージを読み込むことには（とくに商業的な組版では）大きなリスクが伴うのです．しかし，人名などでどうしてもあとから文字が必要になる場合，丸数字などの記号類が必要になる場合，それも見出しなど目立つ部分で必要になることが往々にしてあります．

そのようなどうにもならない場合では文字を画像として作成してそれを貼りこむという「読めればよい」レベルでの解決がなされてきましたが，そもそもその文字を収録しているフォントが存在するのに画像として貼りこむのは本末転倒です．そこで，たくさんの書体でのJIS0208に存在しない文字の出力やotfパッケージを想定していない状況でJIS0208範囲外の文字の出力できるようにするため，以下の条件を満たす「simplecidパッケージ」を公開します．

- CIDで文字を指定できるマクロ\sCIDを提供する．これはotfパッケージの\CIDに相当する，
    - 周囲の書体と文字サイズに追随させる（クラスファイルの設定によるがたいていの場合は問題ない）
    - クラスファイルで指定されているjfmを置き換えない（本パッケージマクロの読み込みの有無だけでは組版結果が変わらない）
- 本文の明朝体・ゴシック体に加えて20書体まで（合計22書体）の多書体化に対応（多少の変更で追加可能）

## ライセンス

LPPLにしておきます．

## 動作環境

- pLaTeX2e（TeXLive2017 frozen or later）（upLaTeX2eは非対応）
- dvipdfmx

simplecidパッケージの実装にはexpl3を用いています．実装で用いられているexpl3の機能で代替が困難で一番新しいものはregexモジュールの`\regex_replace_all:nnN`です．付随するjfm/vfはJIS符号化に依存しています．これらの理由でsimplecidパッケージは2017年以降のexpl3が動作するバージョンのpLaTeX2e専用です．upLaTeX2eでは動作しません．JISではなくutf8に沿うようなtfm/vfファイルを作成すればupLaTeX2eに対応できるとは思いますが，それは今後の課題とします．

現状ではドライバはdvipdfmxのみに対応してます．多少の手作業でmapファイルを書き換えて，パッケージオプションを適切にすればdvipsでも動作はするはずですがテストはしていません．

また，otfパッケージと同様にAJ1であるCIDフォントを想定しています．AI0であるフォントは考慮していません．

## 組方向について

横組専用です．縦組は考慮していません．tfmファイルやvfファイルを構築して，`simplecid.sty`内部のJT1エンコーディングに関連する部分を整備すれば対応可能だと思われますが，現時点では縦組に拡張する予定はありません．

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

インストールは，`simplecid.sty`と`scid-prop.dat`は`$texmf(-local)/tex/latex/simplecid`へ，tfmファイルは`$texmf(-local)/fonts/tfm/simplecid`へ，vfファイルは`$texmf(-local)/fonts/vf/simplecid`へコピーして，必要に応じて`mktexlsr`で`ls-R`を更新してください．もしくはカレントディレクトリにすべてをコピーすれば使えます．


## \usepakageの書式

    \usepackage[<options>]{simplecid}
       <options>     := <option>*
       <option>      := <generateMap>|<embedMap>|<mapname>|<scale>
       <generateMap> := generateMap(\s*=\s*(<true>|<false>))?
       <embedMap>    := embedMap(\s*=\s*(<true>|<false>))?
       <mapname>     := mapname(\s*=\s*<mapfile>)?
       <scale>       := scale(\s*=\s*([1-9][0-9]+)?(\.[0-9]+))

       <true>        := true 
       <false>       := false 
       <mapfile>     := 任意のファイル名


`\usepackage`に与えることのできるオプションは`<key>=<val>`形式です．

- generateMap 
  `generateMap=true`ではsimplecidパッケージが必要とするmapファイルを自動生成します．`generateMap=false`の場合は生成しません．値を省略してgenerateMapだけとした場合はtrueが指定されたとみなされます．デフォルトはgenerateMap=trueです．
- embedMap 
  `embedMap=true`ではsimplecidパッケージが必要とするmapファイル名をdviファイルに埋め込みます．`embedMap=false`の場合は埋め込みません．値を省略してembedMapだけとした場合はtrueが指定されたとみなされます．埋め込まれるmapファイルのファイル名はmapnameオプションで指定されるものです．デフォルトは`embedMap=true`です．
- mapfile
  simplecidパッケージが生成する（そして埋め込むことを指定できる）mapファイルのファイル名を指定します．`mapfile=hoge.map`で，`generateMap=true`の場合に`hoge.map`が生成され，`embedMap=true`の場合に`hoge.map`が埋め込まれます．ファイル名を指定しなかった場合は，`scidfonts-`<driver>`.map`となります．実際のところは`scidfonts-dvipdfmx.map`になります．
- scale
  simplecidパッケージが出力する文字や記号の大きさを表す比率です．10ptの欧文に対してscaleの値を10倍にした大きさの文字を出力します．このオプションはクラスファイルで与えられる`\Cjascale`の値が何らかの事情で実際の和文サイズを表さない場合にのみ使用して下さい．また`\Cjascale`が未定義の場合はpTeXの標準にあわせて10ptの欧文に対して，9.62216ptとなるようにしていますが，このときの0.962216という比率が不正な場合もこのオプションで正しいものに修正してください．

ほかにも`simplecid.sty`の中を見ればわかる通りdvipdfmxオプションが存在しますが，これは`\documentclass`から引き継がれるグローバルオプション`dvipdfmx`の処理と，`\c_sys_backend_str`が未定義のexpl3への対処なのでとくに指定する必要はありません．そもそもsimplecidパッケージはdvipdfmx専用です．

## コマンド

### `\sCID`

    \sCID{<cid number>}

引数にCID番号<cid number>を指定することで，そのCID番号の文字を日本語として出力します．そのCID番号の文字が従属欧文のグリフであろうとも，約物であろうとも常に和文として扱います．このようにすることでtfmの構造をシンプルにして「ただ貼りこむ」を実現します．日本語として扱うようにしているので，ソース内で`\sCID{1234}`のように用いた直後に改行しても空白は入りません．使用される書体やサイズはそこで指定されているものになります．

### `\sCIDSym`

    \sCIDsym{<symbol name>}

引数に<symbol name>なる「記号の名前」を与えることで当該の記号を和文として出力します．現状（2021/05/03 1.0beta）では以下のものを「記号の名前」として使用できます．

- 丸（丸囲みの数字や文字）
- 丸丸（二重丸囲みの数字）
- 黒丸（黒丸に数字や文字）
- 黒角（黒四角に数字や文字）
- 角（四角囲みの数字や文字）
- 丸角（角丸の四角囲みの数字や文字）
- 黒丸角（角丸の黒四角に数字や文字）
- ()（カッコつきの数字や文字）

具体的には`\sCIDSym{丸上}`とすれば「○の中に上」の文字を表しますし，`\sCIDSym{(9)}`は「(9)の組文字」です．otfパッケージに付随する`ajmacros.sty`では数字で指定していましたが，それを「文字」で指定するようにしています．使用される書体やサイズはそこで指定されているものになります．どのような記号が使えるかはAdobeJapan1-7の文字一覧を参照してください．

頻繁に使われる記号や，漢字の異体字でよく使われれる，いわゆる「梯子高」「立崎」のような文字へのショートカットは現状では用意していません．

#### `\sCIDSym`の別名

`\sCIDsym`には以下のような別名を用意しています．

##### `\sCIDMaru`

`\sCIDMaru{<hoge>}`は`\sCIDSym{丸<hoge>}`です．

##### `\sCIDNizyuMaru`

`\sCIDNizyuMaru{<hoge>}`は`\sCIDSym{丸丸<hoge>}`です．

##### `\sCIDKuroMaru`

`\sCIDKuroMaru{<hoge>}`は`\sCIDSym{黒丸<hoge>}`です．

##### `\sCIDKuroKaku`

`\sCIDKuroKaku{<hoge>}`は`\sCIDSym{黒角<hoge>}`です．

##### `\sCIDKaku`

`\sCIDKaku{<hoge>}`は`\sCIDSym{角<hoge>}`です．

##### `\sCIDMaruKaku`

`\sCIDMaruKaku{<hoge>}`は`\sCIDSym{丸角<hoge>}`です．

##### `\sCIDKuroMaruKaku`

`\sCIDKuroMarukaku{<hoge>}`は`\sCIDSym{黒丸角<hoge>}`です．

##### `\sCIDKakko`

`\sCIDKakko{<hoge>}`は`\sCIDSym{(<hoge>)}`です．

### `\sCIDSetting`

標準で割り当てられている書体や多書体化した場合への対処のための設定を`\sCIDSetting`で行います．`\sCIDSetting`は一つの文書ではプリアンブル内で一回のみ使えます．詳細は「デフォルトのフォントと多書体化」の項目で説明します．

## デフォルトのフォントと多書体化

### デフォルトのフォント（明朝とゴシック）

simplecidパッケージのデフォルトは，TeXLive2020のデフォルトと同じく，明朝体はHaranoAjiMincho-Regular.otf，ゴシック体はHaranoAjiGothic-Medium.otfです．


これを以前のデフォルトである，明朝体はRyumin-Light，ゴシック体はGothicBBB-Mediumに変更するには，

    \sCIDSetting{font names => {min  -> A-OTF-RyuminPro-Light.otf,
                                goth -> A-OTF-GothicBBBPro-Medium.otf,
                               },
                }

もしくは

    \sCIDSetting{font names => {min  -> A-OTF-RyuminPro-Light.otf,
                                goth -> A-OTF-GothicBBBPro-Medium.otf,
                               },
                 NFSS names => {JY1//mc/m/n -> min,
                                JY1/gt/m/n  -> goth,
                                JY1/mc/bx/n -> goth,
                                JY1/mc/b/n  -> goth,
                                },
                }

とします．`\sCIDSetting`の引数は連想配列の形式です．キーは「font names」と「NFSS names」の二つであり，それぞれのキーの値もまた連想配列です．

font namesキーの値である連想配列では，キーはmin，goth，00～09，10～19の合計22通りです．これらをIDと呼ぶことにします．min，gothがそれぞれ明朝体，ゴシック体を表します．各IDには実際のフォント名を対応付けます．上の例では，minにはA-OTF-RyuminPro-Light.otfを，gothにはA-OTF-GothicBBBPro-Medium.otfを割り当てています．

NFSS namesキーの値である連想配列では，キーはNFSSでのフォント名で，値は上述のIDです．ここではJY1/mc/m/nにminを，JY1/gt/m/n，JY1/mc/bx?/nにgothを割り当てています．font namesと合わせることで，JY1/mc/m/nにはA-OTF-RyuminPro-Light.otfが，JY1/gt/m/n，JY1/mc/bx/nにはA-OTF-GothicBBBPro-Medium.otfが対応付けられます．

このような対応によって，標準の明朝体がRyumin-Lightであり，ゴシック体がGothicBBB-Mediumである場合に，明朝体（JY1/mc/m/n）のところで`\sCID`などを用いた場合はA-OTF-RyuminPro-Light.otfが，ゴシック体（JY1/gt/m/n，JY1/mc/bx/n，JY1/mc/b/n）のところではA-OTF-GothicBBBPro-Medium.otfで出力されます．

font namesキー，NFSS namesキーは必須ではありません．font namesキーが省略された場合は，

    font names => {min  -> A-OTF-RyuminPro-Light.otf,
                  goth -> A-OTF-GothicBBBPro-Medium.otf,
                  },

が，NFSS namesキーが省略された場合は，

    NFSS names => {JY1//mc/m/n -> min,
                   JY1/gt/m/n  -> goth,
                   JY1/mc/bx/n -> goth,
                   JY1/mc/b/n  -> goth,
                  },

が指定されたことになり，これらは特に上書きされない限り常に設定されます．


### `\sCIDSetting`の連想配列（っぽいもの）

`\sCIDSetting`の引数は連想配列を値として持つ連想配列です．ここではキーと値のペアで構成されるデータ構造を，他の言語の用語を援用して，「連想配列」といっているだけであり，実体はexpl3のproperty listです．expl3のproperty listではキーと値を結びつけるためには「`=`」を用います．ここでは正規表現`/([-=]+\s*)+>/`によって`\sCIDSetting`では「`=`」だけではなく「`=>`」「`->`」なども使えるようにしています．また，expl3のproperty listでは「値」としてproperty listは許されていませんが，引数をデータ構造としてのproperty listに変換するタイミングをごかますことで値がproperty listであるproperty listに見えるようにしています．これらは可読性を少しでもあげるための細工です．リストの最後の項目の末尾に「`,`」を残しているのも可読性，入れ替えやコピーを簡単にするためであって，とくに必要なものではありません．

### 多書体化

NFSS2の枠組みに従った多書体の設定が組み込まれている場合，その情報を`\sCIDSetting`に与えることでその書体の文字や記号を出力できます．ここではTeXLive2020に収録されている`morisawa.sty`（2018/03/06 okumura, texjporg）を読み込んだケースで説明します．ここではいわゆる「モリサワの基本五書体」がdvipdfmxで埋め込める状態になっていることを前提とします．また，クラスファイルはjsclassesのものであるとします（正確には，`\Cjascale`が0.962469であることを前提としています）．

`morisawa.sty`のフォントの定義の本質的な部分は以下の通りです（ここでは横組部分のみを挙げます）．

    \DeclareFontShape{JY1}{rml}{m}{n}{<-> s * [0.961] Ryumin-Light-J}{}
    \DeclareFontShape{JY1}{rml}{bx}{n}{<-> s * [0.961] GothicBBB-Medium-J}{}

    \DeclareFontShape{JY1}{fma}{m}{n}{<-> s * [0.961] FutoMinA101-Bold-J}{}
    \DeclareFontShape{JY1}{fma}{bx}{n}{<-> s * [0.961] GothicBBB-Medium-J}{}

    \DeclareFontShape{JY1}{gbm}{m}{n}{<-> s * [0.961] GothicBBB-Medium-J}{}
    \DeclareFontShape{JY1}{gbm}{bx}{n}{<-> s * [0.961] FutoGoB101-Bold-J}{}

    \DeclareFontShape{JY1}{jun}{m}{n}{<-> s * [0.961] Jun101-Light-J}{}
    \DeclareFontShape{JY1}{jun}{bx}{n}{<->ssub*jun/m/n}{}

この設定の下で，明朝体のデフォルトをrmlに，ゴシック体をgbmに変更します．さらにmg（medium gothic？）にjunを割りあて，フォント変更マクロを定義するのが`morisawa.sty`です．

この状態に，simplecidパッケージを合わせるための設定は

    \sCIDSetting{font names => {00 -> A-OTF-RyuminPro-Light.otf,
                                01 -> A-OTF-GothicBBBPro-Medium.otf,
                                02 -> A-OTF-FutoMinA101Pro-Bold.otf,   
                                03 -> A-OTF-FutoGoB101Pro-Bold.otf,
                                04 -> A-OTF-Jun101Pro-Bold.otf,
                               },
                 NFSS names => {JY1/rml/m/n  -> 00,
                                JY1/rml/bx/n -> 01,
                                JY1/fma/m/n  -> 02,
                                JY1/fma/bx/n -> 01,
                                JY1/gbm/m/n  -> 01,
                                JY1/gbm/bx/n -> 03,
                                JY1/jun/m/n  -> 04,
                                JY1/jun/bx/n -> 04,
                               },
                }

となります．`morisawa.sty`はpLaTeX2e標準の設定は変更せず別の設定に切り替えるという仕様であるので，`\sCIDSetting`もそのようにしてみました．この状態の下，たとえば

    \textbf{中ゴシック\sCIDMaru{1}}

    \textmg{じゅん\sCIDMaru{1}}

とすれば，丸数字はそれぞれの書体でそのときのサイズのものが出力されます．


多書体化の場合はpLaTeX2eでの和文の扱いの知識が必要ですが，使用したい書体に対してNFSSでどのような名前をつけているのか（`\DeclareFontShape`でどのように宣言しているのか）と，実際のフォントのファイル名が分かればいいだけです．それが分からない場合でも，`\sCID`を使った際に適切な設定がなされていないときにはエラーがでてhによる詳細表示でNFSS名が示されるので使えばよいです．

## 注意など

NFSSでの名前と実フォントは1対1ではありません．また，`\DeclareFontShape`で`ssub`や`sub`を使った代替まで探査するのはあまりにつらい（できるのかも分かりません）ので，間にIDをはさんで手動で対応をつけるようにしました．IDは任意の文字列にするほうが自然だとは思いますが，tfmの名前を決め打ちにせざるを得ないのでIDはtfm名の接尾辞としています．IDは上の例では00のように二桁になるようにパディングしていますが単に0--9であっても内部でパディングします．パディング前と後、つまり00と01などは同じIDとみなされます．

パディングに関しては，expl3のtoken listとstringの差で混乱したためすっきりしていないところがあります．`\string`や`\the`で生成される「文字列」のカテゴリーコードが12であることに関わっているのですが，何かの操作の結果で現れる「文字列」がどちらなのかを間違えると一見理不尽な動きになるので注意が必要です．map系の関数を多用するとそのあたりで混乱しそうです．というか，しました．


このパッケージを使ううえではIDと実フォント，NFSS名とIDの対応がもっとも重要なので，可読性を少しでもあげるためにも，`\sCIDSetting`で定める対応ではは，本来は`=`であるところに`=>`や`->`を許容して、他の言語での連想配列のようにしています．上での例のように，対応の階層に応じて用いる記号を変えることができます．実際は単なる正規表現による置換であってsyntax sugarにすぎませんが，表のような形で整理できるので混乱はさけられるでしょう．

縦組みに関しては，需要が少ないのと，文字や記号を出すだけの本パッケージではtfmまで作らなくても誤魔化せるかなという思いはあります（回転させてベースラインを調整すればいい？）．upLaTeX2eに関しては，upTeXのjfmとjvfの構造をあんまり把握していないのでそこから考えないといけないため保留です．このあたりは，pTeXがjisがベースであるところがupTeXではUTF8であろうというくらいの理解しかありません．

また，漢字の異体字でよく使うものへのショートカットについてはどのようなインタフェースがよいのか悩んでいます．「梯子高」は「高」に関連付けるべきでしょうが，「斉」のようにたくさんの異体字があるものはどうするか．「斉1」，「斉2」のように連番をつけるのは避けたいですが，IVSにしたって連番みたいなもので番号と字形に直感的にわかるつながりはありません．なるべく汎用的かつ一般的なもので，直感的なものにしたいですがよくわかりません．

## 内部構造の覚書

本パッケージの本質は

- CID番号から呼び出すtfmと文字コードを決定する．
- tfmからvfによって実フォントのCID番号の文字を呼び出す．

の二点にあります．残りはそれをどのように呼び出すか，dviwareに渡すかという話です．商と余りの計算，いわゆる「map」の多さを考慮してexpl3を採用しています．デメリットもあるかもしれませんが，expl3の豊富なデータ構造とmap関数で見た目はともかく，比較的容易にマクロは実装されています．

`simplecid.sty`に記述されているマクロに関しては，expl3であること以外には複雑なことはしていません．しかしtfmとvfの構造はブラックボックスになっているので，それに関して記述しておきます．


simplecidパッケージのtfmは正確にはjfmであり10ptの正方形で，高さと深さの比は880:120，つまりメトリックとしてはotfパッケージと同じです．ただし，すべての文字を`CHARSINTYPE 0`にしています．glue/kernも一切設定していません．単純に並べることだけを想定しています．また，`\Cjascale`が未定義なときはpTeXの標準にあわせて0.962216にしており，10ptベースなのでこの値が直接`\DeclareFontShape`のスケールファクタになります．jsclassesのように10pt欧文に13Qを割り当てる状況下では`\Cjascale`が0.92469と定められていることを前提としています．この前提が崩れている場合や，`\Cjascale`が定義されているのにもかかわらず，パッケージで比率が変更されるケースでは比率を注意する必要があります．これは例えば，`jarticle.cls`のようなjclassesのもとで，TeXLive2020のmorisawaパッケージを用いた場合に顕わになります．cls側で`\Cjascale`を0.962216にしているにもかかわらず，morisawaパッケージが`\Cjascale`が0.92469であるときのスケールファクタを用いているからです（実際のところはmorisawaパッケージはjscalssesのもとでの使用が前提なのでしょう）．このような混乱に対処するために，otfパッケージが導入しているように，simplecidパッケージのscaleオプションでパッケージ内でのみ有効となるスケールファクタを導入しています．

さて，pTeXのjfmはJISがベースです．JISは1面が94区94点の8836（=94 * 94）文字から構成されています．一方，CIDはおおざっぱに約28000文字です．したがって，四つのjfmがあればCIDの文字数は確保できます．

与えられたCID番号$N$に対して，$N -1 = n \times 8836 + R$ ($0 \le R<8836$)と割り算することで，$n$が対応するtfmの番号となります．この$R$を，$R = (p-1) * 94 + (q -1)$ ($0 \le q <94$)と表すことで，cid番号$N$に対する区$p$と点$q$を割り出します．そして$p*256+q$とすることで`\kuten`の引数にしています．

以上より，与えられたCID番号$N$に，tfm $n$の$p$区$q$点の文字が対応付けられます．`simplecid.sty`ではこの計算を行っています．

そしてtfm $n$に対応するvfでは，tfm $n$での区点コード$p$区$q$点（より正確には$(p+32)\times256+(q+32)$）に応じて次の表のCID番号を順番に対応付けます．vfから参照されるtfmにはIdentity-Hのcmapで実CIDフォントを割りあて，vfで与えられるCID番号の文字を最終的に出力させます．


|tfm $n$|CID $N$|
|:---:|:---:|
|0|1～8836|
|1|8837～8836*2=17672|
|2|17673～8836*3=26508|
|3|26509～8836*4=35344|


`simplecid.sty`の残りの処理は，`\DeclareFontShape`の生成，mapファイルの生成，およびそれらを補助することがらです．

## 謝辞
simplecidパッケージは，当然のことながらOTFパッケージの，tfmとvfの対応によって対応するCID番号を定めるというアイデアを利用しています．また，多書体化を容易にしたい，AdobeJapan1-7の文字を周囲の書体あわせて簡単に出力するということそのものは以前から考えていたのですが，しばらく同じ職場で働いていたA氏との会話でいろいろと熟成していきました．とくにpTeXベースならばtfmが四つあればAdobeJapan1-7はカバーできるというのはA氏による指摘でした．

また，expl3のおそらく日本語での最初の入門記事であろう朝倉さんのブログ（使用例としては鹿野さんのJSONパーサもあります）とTeX Conf2017での講演は大きな刺激でした．どの言語でもやたらとmap系の関数を使う傾向がある人間としては，その講演を聞いてinterface3.pdfを見てTeXでもmapが用意されているのを発見したのがexpl3を触るきっかけでした．また，siunitxパッケージがexpl3と従来のLaTeX2eのマクロを混ぜて書かれているのをみて実際に使う方法を理解できました．`\special`の埋め込みに関しては，ZRさんのpxchfonのものを使わせていただきました．

これらの制作者の皆さんに感謝を．LaTeXやexpl3を実装されているLaTeX Teamの皆さんにも感謝を．