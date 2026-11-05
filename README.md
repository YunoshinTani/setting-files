# VS Code 設定の運用

学校用・部活用・既定のプロファイル設定を、共通ソースと差分から生成します。
完成版はこのフォルダ内に出力します。適用するときは、下表の配置先へコピーしてください。

2026-10-18に配布用・このPC用の6設定を再生成し、Nbedひな型、LaTeX環境、
このPCの既定・学校・部活プロファイルへ適用済みです。
適用前のファイルは `backups/2026-10-18-before-apply-f4fb0c5a/` に保存しています。

## LaTeX共有設定の運用

`projects/school-latex/` は、`.vscode/`・`scripts/`・`config/` をまとめて配布する構成です。
新しいレポートにはTeXファイルだけを置けば共通設定でビルドできます。
各フォルダーの `.latexmkrc` は任意です。エンジンはTeX先頭の `% !TeX program = ...` で選べます。
編集・自動保存・保存時ビルド・補完・折り返しを共有し、テーマ・フォント・PDF表示は個人設定です。
詳しい一覧は [LaTeX共有設定の運用](projects/school-latex/.vscode/README.md) を参照してください。
共有プロジェクト側の設定が適用されるため、プロファイルの再生成は不要です。

## Nbed設定の確定版（2026-10-18）

`V:/2_robotics/11_template/template-nbed-project` で確定した設定一式を
`projects/robotics/` に反映しました。`.vscode/` の共有設定・6種類のタスク・清掃処理・
推奨拡張・運用説明に加え、`.clangd`、`.clang-format`、`.gitignore`、
`platformio.ini`、`compiledb.py` を含みます。生成物やPC固有のデバッグ設定は含めません。

共通ソースはインデント自動判定、日本語の許可、文字列内の貼り付け、Markdownの空白保持、
1秒後の自動保存とタスク前保存を更新しました。80文字の目安線はC/C++に限定しました。
部活用差分にはC/C++のファイル全体整形とTODO Treeの検索除外を反映しました。
テーマ・フォント・ターミナルなどの個人設定は、共有プロジェクトへ持ち込みません。

配布用 `profiles/` とこのPC用 `profiles-local/` の各3種類を生成済みです。
これらは配布ファイルであり、稼働中のVS Codeプロファイルへのコピーは別の配置操作です。
詳細は [部活用設定一式](projects/robotics/README.md) と
[共有設定の運用](projects/robotics/.vscode/README.md) を参照してください。

## Web開発設定（2026-11-03）

`V:/5_server/tani-server1-dev` のWeb向け設定を [projects/web/](projects/web/README.md) に反映しました。
静的サイトのHTML・CSS・JavaScript、C11/C++17のCGI、Python公開ツールを対象とし、
PlatformIO・STM32・HAL向けの設定を外しています。言語別の編集・整形・診断設定、
既存の公開・検証タスクとclangd更新タスク、推奨拡張、`.clangd`、`.clang-format`、
`web/tools/compile_commands.py`、運用説明を含みます。

コンパイルDBの絶対パスはコピー先で生成します。WindowsではMSYS2のPOSIX版GCCを使用し、
標準ヘッダーの検索先をWindows版clangdから読めるパスへ変換します。
CGI 8本と共通テスト1本、および主要な共通ヘッダーの診断とC/C++の整形をclangd 23.1.0で確認しました。
実データ・接続設定・生成DB・バイナリは配布用設定に含めません。
この共有設定の追加による既定・学校・部活プロファイルの再生成や変更はありません。

## ディレクトリ構成

- このPCに配置する完成版: `vscode/profiles-local/`
- 他PC向けの完成版: `vscode/profiles/`
- 共通設定とプロファイル差分の編集元: `vscode/sources/`
- 学校用・部活用・Web用の共有設定: `vscode/projects/`
- 元設定のバックアップ: `vscode/backups/2026-10-11-before-optimization/`

## 配置する5つの設定

| 役割 | このPCに配置するファイル | 配置先 |
| --- | --- | --- |
| 既定 | [profiles-local/default/settings.json](profiles-local/default/settings.json) | `C:\Users\tani\AppData\Roaming\Code\User\settings.json` |
| 学校 | [profiles-local/school/settings.json](profiles-local/school/settings.json) | `C:\Users\tani\AppData\Roaming\Code\User\profiles\-68272332\settings.json` |
| 部活 | [profiles-local/robotics/settings.json](profiles-local/robotics/settings.json) | `C:\Users\tani\AppData\Roaming\Code\User\profiles\7db525bf\settings.json` |
| 学校の共有設定 | [projects/school-latex/.vscode/settings.json](projects/school-latex/.vscode/settings.json) | `V:\1_school\template\settings.json` および各LaTeXプロジェクトの `.vscode/settings.json` |
| 部活の共有設定 | [projects/robotics/.vscode/settings.json](projects/robotics/.vscode/settings.json) | `V:\2_robotics\11_template\template-nbed-project\.vscode\settings.json` および各Nbedプロジェクト |

学校の共有設定は [projects/school-latex/](projects/school-latex/) の `.vscode/`・`scripts/`・`config/` とセットです。
`.vscode/settings.json` だけをコピーせず、必要な3フォルダーを親フォルダーへまとめて配置してください。
各レポートに `.latexmkrc` を配布する必要はありません。
部活の共有設定は [projects/robotics/](projects/robotics/) の設定一式で管理します。
既存プロジェクトへ適用するときは、ボード・依存ライブラリなどの `platformio.ini` の値を確認してください。
各フォルダの `extensions.json` は必要な拡張機能の推薦です。自動インストールはしません。

元ファイルは `backups/2026-10-11-before-optimization/` に保存済みです。
このバックアップの既定設定には、取り消す前の LaTeX 追記が含まれています。

## 共通設定を一度だけ編集する

VS Code のプロファイルには「別プロファイルの設定を継承し、差分だけ上書きする」機能がありません。
既定からコピーして作ったプロファイルも、その後の変更は自動反映されません。
公式の「すべてのプロファイルに設定を適用」は利用できますが、ここでは編集元を一元化し、
配置時に全設定を含む完成版を生成する方法を用意しました。
[VS Code プロファイルの仕様](https://code.visualstudio.com/docs/configure/profiles)

編集するファイル:

- [sources/common.settings.jsonc](sources/common.settings.jsonc): 全プロファイル共通の個人設定
- [sources/default.overrides.jsonc](sources/default.overrides.jsonc): 既定の差分
- [sources/school.overrides.jsonc](sources/school.overrides.jsonc): 授業・レポート用の差分
- [sources/robotics.overrides.jsonc](sources/robotics.overrides.jsonc): 部活用の差分
- `machine/*.local.jsonc`: このPCの実行ファイル・接続情報

変更後はPowerShell 7で以下を実行します。VS Code本体や既存プロジェクトには書き込みません。

```powershell
pwsh -File V:\7_script\vscode\scripts\Build-Profiles.ps1
pwsh -File V:\7_script\vscode\scripts\Build-Profiles.ps1 -IncludeMachine
pwsh -File V:\7_script\vscode\scripts\Validate-Settings.ps1
```

引数なしで移植用 `profiles/`、`-IncludeMachine` でこのPC用 `profiles-local/` を生成します。
同じキーは後の差分が優先され、オブジェクトは再帰的に統合、配列は全体を置き換えます。
生成ファイルを直接編集すると、再生成で失われます。恒久的な変更は `sources/` または `machine/` へ戻します。
学校用のPDF関連付けと部活用の補完設定も、この統合方法で共通設定と共存します。
生成ファイルの先頭に生成元と再生成コマンドを記録します。設定理由のコメントは編集元に置きます。

VS Code の設定画面で変更した値も、運用を継続するなら編集元へ転記してください。
プロファイルの Settings Sync は完成版を同期します。ソースの統合処理は別途実行が必要です。
既に「すべてのプロファイルに設定を適用」にした項目があれば、その値が共通で適用されます。
学校・部活で変える項目（例:ズーム値、言語ツール）はその対象にしないでください。
設定の適用順と、言語別設定が通常の設定より優先される点は
[VS Code の設定仕様](https://code.visualstudio.com/docs/configure/settings) を参照してください。

## 一覧・検索・監視の除外方針

| 対象 | エクスプローラー | 通常検索 | 監視 |
| --- | --- | --- | --- |
| ルート直下の `.vscode/`・主要設定ファイル | 表示 | 除外 | 対象 |
| ルート直下の `.cache/` | 非表示 | 除外 | 部活用の共有設定で除外 |
| ルート直下の `compile_commands.json` | 非表示 | 除外 | 対象（clangdのDB更新検知用） |
| ルート直下の `build/`・`.pio/` | 表示 | 部活用の共有設定で除外 | 部活用の共有設定で除外 |
| ルート直下の `export/` | 表示 | 学校用の共有設定で除外 | 学校用の共有設定で除外 |

共通プロファイルの検索除外は `.vscode/`、`*.code-workspace`、`.editorconfig`、
`.gitignore`、`.gitattributes`、`.clangd`、`.clang-format`、`.clang-tidy`、`.latexmkrc`、
`platformio.ini` です。共有設定にも各プロジェクトに必要な検索除外を含めています。
`extra_script.py` は実行するコードなので検索対象に残します。
JSON・YAML・INIを拡張子ごと除外する指定は使いません。

キャッシュとコンパイルDBは直接編集しない生成物なので一覧から隠します。
設定ファイルと、ログ・PDFを確認する出力フォルダは一覧に残します。
非表示はファイルの削除やclangdによる読み込み禁止ではありません。

追加した除外はワークスペースフォルダ直下が基準です。
`src/build/`、`src/.cache/`、`tests/compile_commands.json` などは除外しません。
複数ルートの場合は各ワークスペースフォルダが基準になります。
VS Code標準の除外や `.gitignore` による除外は別途適用されます。

設定を含めて検索するときは、検索ビューの「除外設定と無視ファイルを使用」を一時的にオフにします。
非表示の生成物を一覧に戻すときは、プロジェクトの `files.exclude` で
`.cache` や `compile_commands.json` の値を `false` にします。
[検索の除外仕様](https://code.visualstudio.com/docs/editing/codebasics#_advanced-search-options)、
[Globの相対パス仕様](https://code.visualstudio.com/docs/editor/glob-patterns)

## 今回整理した内容

### 共通とPC依存

フォント・テーマ・表示・自動保存・Markdown・Copilotなどの共通の好みを一か所に集約しました。
ズームは既定 -1.5、学校 -2、部活 -3という既存の好みを維持しました。
新規ウィンドウで `robotics` を使う指定は `machine/*.local.jsonc` に分離し、このPC用の生成結果だけに含めます。
PowerShellの絶対パスをVS Codeの自動検出に変更しました。元の
`C:\Program Files\PowerShell\7\pwsh.exe` は、このPCには存在しませんでした。
別ユーザーを指していたFlutter SDKパスはテンプレートから除外しました。
SSHの接続先・ripgrep・clangdのPC固有のパスは `machine/` に分離しています。

### 学校用

全言語の整形担当になっていた clangd をC/C++に限定し、LaTeX・BibTeXでは自動整形を無効にしました。
C/C++拡張の補完を無効にしてclangdとの二重動作を防ぎ、デバッグ機能は利用可能な構成です。
PDF表示の好みは学校プロファイルへ置き、保存時ビルド・折り返し・補完は共有プロジェクトにも明示しています。
個人辞書と、r08ec-exp等で使う共有TeX用語はそれぞれ元の配置を維持しました。
未導入のGitLensに固定されていたモデル設定等は除外しました。

LaTeXは2通りの運用を用意しています。

1. 新規・共有プロジェクト: `projects/school-latex/` の共通ビルドを使います。省略時はupLaTeXで、TeX先頭の `% !TeX program = ...` で変更できます。個別の `.latexmkrc` は任意です。
2. 既存文書: 学校プロファイルの5種類のレシピを使い、ルート文書の先頭で `% !LW recipe` により選択。

既存文書の例:

```tex
% !LW recipe = latexmk (LuaLaTeX)
\documentclass{ltjsarticle}
```

レシピ名は `latexmk (uplatex + dvipdfmx)`、`latexmk (platex + dvipdfmx)`、
`latexmk (LuaLaTeX)`、`latexmk (pdfLaTeX)`、`latexmk (XeLaTeX)` です。
未指定では従来の日本語レポートに合わせてupLaTeXを使います。
`% !TeX program = lualatex` はエンジンを直接呼び出し、latexmkの文献・再実行管理を迂回するため、
レシピ指定を使用してください。`% !TeX root` は分割文書のルート指定に引き続き使えます。
共有テンプレートではLaTeX Workshopによる直接実行を無効にし、共通処理が許可されたエンジン名だけを読みます。
その後は必ずlatexmkを通すため、文献・相互参照の再実行管理を維持します。
[LaTeX Workshop の公式ビルド仕様](https://github.com/James-Yu/LaTeX-Workshop/wiki/Compile)

元の学校設定は dvipdfmx をユーザーの `.latexmkrc` に頼っていました。
新しい共有設定は `-norc -r` でプロジェクト設定を明示的に読み、別PCのユーザー設定に依存しません。
LuaLaTeX・XeLaTeXの指定の後に `-pdf` を加えるとpdfLaTeXに戻ってしまうため、その組合せも除去しました。
日本語文献・索引用のupbibtex/upmendex、およびBiberの通常動作を設定しています。
不要なBiberの文字変換オプションや、SyncTeXを消す独自クリーン一覧は引き継いでいません。
PDFと補助ファイルは、既存テンプレートの運用に合わせて `export/` にまとめます。
E_CdSの `build/` 設定は既存プロジェクト側で管理します。

このPCは `TEXLIVE_WINDOWS_TRY_EXTERNAL_PERL=1` が有効で、MSYS2のPerlを利用していました。
実測ではBibTeXに渡す文献検索パスが `/v/...` になり、Windows版BibTeXが `.bib` を発見できませんでした。
学校プロファイルとLaTeX共有設定に、TeX Live内蔵Perlを選ぶ環境変数 `0` を設定しました。
TeX LiveやMSYS2のシステム全体の設定は変更せず、ビルドツールと新規ターミナルに適用します。
根拠はこのPCの `C:\texlive\2026\bin\windows\runscript.tlu` のPerl選択処理です。
TeX Live以外のディストリビューションではこの環境変数は通常不要です。

### 部活用

補完の文字列内有効化、PlatformIOの起動の好み、Pythonの型チェック、Gitの好み、
HTML/JavaScriptの整形、個人辞書を維持しました。LaTeX設定は含めていません。
共有設定にはコード編集・自動保存・ツール動作・TODO検索を含めます。
テーマ・フォント・ターミナル・画面倍率などの個人設定は共有しません。
共有設定自体は `.vscode/`・`.clangd`・`.clang-format` とルート直下の成果物を検索除外します。
共通プロファイルには、従来の他の主要設定ファイルの検索除外も残しています。
設定は一覧に表示し、コンパイルDBの更新は監視します。
ヘッダーの `*.h → cpp` という既存のプロジェクト方針は維持しています。
C主体の別プロジェクトでは、この関連付けをそのプロジェクトに合わせて変更してください。

コンパイルデータベースの参照先は、`compiledb.py` が出力するプロジェクトルートです。
`.clangd` の `CompilationDatabase` はフォルダを指定する設定です。
Cファイルにも一律追加していたC++23・例外処理・RTTIのフラグを外して、実際のビルド情報を使います。
元の診断・命名規則は保持しています。
[clangd の設定仕様](https://clangd.llvm.org/config)、
[PlatformIO のコンパイルデータベース仕様](https://docs.platformio.org/en/latest/integration/compile_commands.html)

## 別PCに持っていくとき

個人用プロファイルには `profiles/` の移植用設定を使います。
共有プロジェクトには `projects/` の設定をコピーします。
`machine/`、`profiles-local/`、`backups/`、`.verification/` は他の人に渡しません。
学校ではTeX Live、部活ではPlatformIOとclangd、および必要な拡張機能を導入してください。
フォント・テーマ・アイコンは既存の好みを維持しているため、未導入のPCでは別途導入か変更が必要です。
プロファイルIDはPCごとに異なります。新しいPCでは該当プロファイルの
「ユーザー設定(JSON)を開く」で配置先を確認してください。
配布用 `profiles/` には特定のプロファイル名を前提とする `window.newWindowProfile` を含めません。
新規ウィンドウで使うプロファイルを固定したい場合だけ、そのPCの `machine/*.local.jsonc` に指定します。

同じ出力を再現する必要がある共同作業では、TeX Liveの年版・追加パッケージ・使用フォントも揃えます。
パッケージの対応エンジン、用語集等の外部ツール、非標準のPlatformIO保存先はプロジェクト個別の設定です。
このテンプレートはそれらを置く場所を明確にし、通常の文書切替でグローバル設定を変更せずに済む構成です。

検証結果と確認した範囲は [VERIFICATION.md](VERIFICATION.md) に記録しています。
