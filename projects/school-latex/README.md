# 学校用 LaTeX プロジェクト設定

`.vscode/`、`.latexmkrc`、`.gitignore` をレポートのルートフォルダへコピーします。
既存の設定ファイルがある場合は内容を統合してください。
TeX Live と LaTeX Workshop があれば、学校用プロファイル以外でも利用できます。
編集後1秒の自動保存、保存時ビルド、インデントの自動判定、文書の折り返し・補完を共有します。
テーマ・フォント・ターミナルの選択・PDF表示の好みは個人設定に残します。
追加した設定の一覧は [.vscode/README.md](.vscode/README.md) に記載しています。

## エンジンの変更

`.latexmkrc` の次の行の `'uplatex'` を文書に合わせて変えます。

```perl
my $engine = $ENV{'LATEX_ENGINE'} || 'uplatex';
```

通常はこの既定値を使います。CLI・CIで環境変数 `LATEX_ENGINE` を指定した場合だけ、
その値を優先します。意図しない切替を避けるため、この環境変数は常設せず、
検証等で必要なときだけ指定してください。

| 文書の前提 | engine |
| --- | --- |
| jsarticle に uplatex オプションを指定 | uplatex |
| pLaTeX 前提の古い授業テンプレート | platex |
| ltjsarticle / jlreq + LuaTeX-ja | lualatex |
| 欧文で pdfLaTeX を要求するテンプレート | pdflatex |
| XeLaTeX / fontspec を要求するテンプレート | xelatex |

既定のエンジン選択をプロジェクトに保存するため、全員が同じビルド方式を共有できます。
クラス・パッケージ自体が対応していないエンジンへの切替では、TeX本文側の変更も必要です。
複数エンジンの独立した文書は、それぞれ別フォルダに `.latexmkrc` を置きます。
ルート文書がサブフォルダ内なら、そのルート文書と同じ場所に配置します。

## 操作

VS Code: `LaTeX Workshop: Build LaTeX project` を実行します。
初期状態では upLaTeX → dvipdfmx で `export/` にPDFと補助ファイルを生成します。
`$aux_dir` は固定せず、補助ファイルの出力先も `$out_dir` に従います。
`-outdir` で出力先を変更した場合も、補助ファイルを同じ場所にまとめられます。
出力先の監視・検索除外はワークスペース直下の `export/` の内容に適用します。
`src/export/` などの同名ディレクトリは除外されません。
ルート文書をサブフォルダに置く場合、出力先もその文書に合わせて移るため、
必要なら `reports/export/**` のように出力先の相対パスを個別に追加してください。
`latex-environment` のように複数文書を親フォルダでまとめて開く構成では、
各文書の出力を対象にする `**/export/**` と、各文書の設定を対象にする
`**/.latexmkrc` を検索除外に使い、監視除外も `**/export/**` にします。

通常検索では、ルート直下の `.vscode/`、`*.code-workspace`、`.editorconfig`、
`.gitignore`、`.gitattributes`、`.latexmkrc` も除外します。
これらの設定とPDFの出力先 `export/` は一覧に残し、ルート直下の `.cache/` だけを隠します。
設定を検索する場合は、検索ビューの「除外設定と無視ファイルを使用」を一時的にオフにします。

ターミナル（ルート文書のフォルダ）:

```powershell
$env:TEXLIVE_WINDOWS_TRY_EXTERNAL_PERL = '0'
latexmk -norc -r .latexmkrc main.tex
latexmk -norc -r .latexmkrc -c main.tex
```

`main.tex` は実際のファイル名に置き換えます。後者は補助ファイルの清掃です。
最初の環境変数はWindowsのTeX Liveで内蔵Perlを使う指定です。
VS Code内ではビルドツールと新規ターミナルに同じ指定を設定済みです。
macOS / Linux ではこの環境変数の指定は不要です。
ビルド直後の自動清掃は行わず、増分ビルド・診断用ログ・SyncTeXを利用します。
`-C` はPDFも削除するため、通常の清掃には使用しません。
エンジンを切り替えた直後は、清掃してから再ビルドしてください。

`% !TeX root = main.tex` は分割ファイルからルート文書を見つける用途で利用できます。
`% !LW recipe` や `% !TeX program` によるビルド選択はこの共有テンプレートでは無効です。
latexmk が文献・相互参照の再実行を管理し、biblatex の Biber も必要時に実行します。
日本語 BibTeX は upLaTeX に upbibtex、pLaTeX に pbibtex を指定済みです。
用語集・特殊な生成ツール・shell escape が必要なパッケージは `.latexmkrc` で個別設定します。
