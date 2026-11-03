# 検証結果

## PlatformIOスクリプトのPylance診断を限定調整（2026-10-18）

- 配布元の `projects/robotics/compiledb.py` で、実行時だけ読み込まれる `SCons.Script` と、SConsが提供する `Import`・`env` の3箇所だけに診断別の解析除外を追加。
- `template-nbed-project/compiledb.py` にも同じ内容を適用し、説明書を同期。
- 変更前後のPython構文木が一致し、実行処理が変わっていないことを確認。
- プロジェクトで `pio run --target compiledb` を実行し、成功を確認。
- Python診断の一括無効化やPC固有パスの追加は行わず、プロファイル設定も変更していません。

更新前のファイルは `backups/2026-10-18-before-pylance-notes-d499be1c/` に保存しています。

## 最終生成・各環境への適用（2026-10-18）

- 配布用3種・このPC用3種を再生成し、全15 JSON/JSONCファイルの既存検証に合格。
- VS Codeの登録情報から `school` と `robotics` のプロファイルIDを確認。
- `projects/robotics/` の設定10ファイルを `template-nbed-project` に適用。
- 学校用共有設定・推奨拡張・説明書の3ファイルを `latex-environment/.vscode/` に適用。
- LaTeX環境は複数文書を親フォルダで開く構成なので、検索の `**/.latexmkrc`・`**/export/**` と監視の `**/export/**` を維持。
- `profiles-local/` の3設定を、このPCの既定・学校・部活のユーザー設定へ適用。
- 適用先の計16ファイルが配置元または用途に応じた変換結果と一致することをSHA-256で確認し、適用先JSONCの読み込みも確認。
- このPC用のclangd・ripgrepの実行ファイルが実在することを確認。
- Nbedのソース・使用例・LaTeX環境のビルド設定など計27ファイルをハッシュ比較し、不変であることを確認。

適用前のファイルと配置記録は `backups/2026-10-18-before-apply-f4fb0c5a/` に保存しています。
今回はファイルへの適用と内容の検証まで実施し、VS Codeの再起動・ビルド・実機書き込みは行っていません。

## 配布用プロファイルの名前依存・未使用設定を整理（2026-10-18）

- 3種類の `sources/*.overrides.jsonc` から `window.newWindowProfile` を外し、各 `machine/*.local.jsonc` に移動。
- 配布用 `profiles/` には特定のプロファイル名を含めず、このPC用 `profiles-local/` では既存の `robotics` を維持。
- 部活用ソースから未使用の `claudeCode.preferredLocation` と `redhat.telemetry.enabled` を削除。
- 配布用3種・このPC用3種を再生成し、全15 JSON/JSONCファイルの既存検証に合格。
- 編集元・機種別差分・生成結果の全13設定を更新前と比較し、依頼された項目以外が変わっていないことを確認。
- 確認ダイアログの省略設定、信頼設定、個人辞書は維持。

更新前の内容は `backups/2026-10-18-before-profile-portability-948cf56a/` に保存しています。
稼働中VS Code設定への配置は行っていません。

## LaTeX共有設定の追加（2026-10-18）

`latex-environment/.vscode/settings.json` と `projects/school-latex/.vscode/settings.json` に、
共通・学校用プロファイルから共有する編集・自動保存・保存時ビルド・補完・折り返しを反映しました。
共有設定の説明書も両方の `.vscode/README.md` に追加しています。

- JSONCの読み込み、66設定のキー登録、拡張設定の型・選択肢・非推奨指定を確認。
- `Validate-Settings.ps1` による配布元の全15 JSON/JSONCファイルの検証に合格。
- 共有に取り込んだ値が、生成済み学校用プロファイルの値と一致することを確認。
- 既存のビルド・清掃コマンド、エンジン選択、Perl設定、共有辞書が不変であることを確認。
- 両設定の差は、親フォルダ用と単独レポート用の検索・監視の除外範囲だけであることを確認。
- プロファイルの編集元・生成済み6ファイル・Nbed配布設定・使用例の本文とビルド設定など、49ファイルのハッシュが不変であることを確認。

既存プロファイルから共有先への反映なので、プロファイルのソース変更・再生成は行っていません。
TeXのビルド処理自体は変更していないため、今回はPDFビルドとエディター実画面の操作は再実行していません。
更新前のファイルは `backups/2026-10-18-before-latex-shared-43fe3dff/` に保存し、
検証記録は `.verification/latex-shared-20261018.json` に記録しました。

## Nbed設定の確定版反映・生成（2026-10-18）

- `template-nbed-project` の確定設定10ファイルを `projects/robotics/` へ同期し、SHA-256の一致を確認。
- 共通ソースへインデント自動判定、文字列内の貼り付け、日本語の許可、Markdownの空白保持、自動保存待ち時間、タスク前保存を反映。
- 80文字の目安線をC/C++に限定し、部活用差分へファイル全体整形とTODO Treeの検索除外を反映。
- 配布用 `profiles/` とこのPC用 `profiles-local/` の各3種、計6プロファイルを生成。
- `Validate-Settings.ps1` で全15 JSON/JSONCファイル、LaTeXレシピ参照、エンジン引数、移植用パスの検証に合格。
- 全6プロファイルの編集・保存・Markdown・検索設定と、部活用C/C++設定が確定値であることを確認。
- 既存のテーマ・フォント・画面倍率・ターミナル・個人辞書・PC固有パスを生成前後で比較し、一致を確認。
- 学校用LaTeX設定が生成前後で一致し、学校用ソース・共有テンプレート・machine設定・生成スクリプト・稼働中VS Code設定の計16ファイルが不変であることを確認。
- 再生成をもう一度実行し、全6プロファイルのSHA-256が変わらないことを確認。

更新前の内容は `backups/2026-10-18-before-nbed-final-67a5054b/` に保存しました。
検証記録は `.verification/nbed-final-20261018.json` にあります。
今回は配布ファイルの反映・生成まで実施し、稼働中VS Code設定への配置は行っていません。
ビルド関連ファイルは既に検証したひな型と同一です。今回はエディター実画面の操作・ファームウェアビルド・実機書き込みは再実行していません。

## 共有 .latexmkrc の更新（2026-10-18）

- `projects/school-latex/.latexmkrc` を公開用LaTeX環境と同じ設定内容に更新。
- 既定のupLaTeXを維持し、`LATEX_ENGINE` によるCLI・CI用の一時上書きに対応。
- `$aux_dir` の固定指定を削除し、補助ファイルの出力先は `$out_dir` に従う構成に変更。
- 更新前のファイルを `backups/school-latex-before-update-20261018-141926/` に保存。
- TeX Live内蔵Perlで構文検査に合格。既定値と5エンジンのモード・コマンド・診断オプション、
  不正なエンジン値を拒否することを設定読み込みテストで確認。
- コメント・空行を除き、公開用upLaTeX使用例の設定と一致することを確認。
- `Validate-Settings.ps1` による全14 JSON/JSONCファイルの検証に合格。
- プロジェクト用READMEと管理元READMEのエンジン指定の説明を更新。

今回はPDFの再生成、プロファイルの再生成、既存レポートへの設定の配布は行っていません。
プロファイル生成スクリプトはこの `.latexmkrc` を生成・上書きしないため、再生成は不要です。

## 設定の最終生成（2026-10-18）

- 共通プロファイルと共有設定に、ルート直下の `.vscode/`・主要設定ファイルの検索除外を追加。
- `.cache/` と `compile_commands.json` を一覧から隠し、設定ファイルと出力フォルダは表示。
- 部活用の監視除外はルート直下の `.cache/`・`.pio/`・`build/`、学校用は `export/`。
  ルートのコンパイルDBは監視対象に残し、`src/build/` 等に一致する再帰的除外は使用しない。
- 設定・生成スクリプトのコメントを整理し、生成ファイルに生成元と再生成コマンドを明記。
- `.clangd` の冗長な説明・値と矛盾するコメントを整理。コメントと空白を除いた内容の一致を確認。
- `Build-Profiles.ps1` と `Build-Profiles.ps1 -IncludeMachine` で計6ファイルを生成。
- 全6プロファイルに検索・表示の除外設定が含まれること、および再生成前後のSHA-256一致を確認。
- `Validate-Settings.ps1` による全14 JSON/JSONCファイル、レシピ参照、エンジン引数、移植用パスの検証に合格。

除外仕様は [VS CodeのGlob仕様](https://code.visualstudio.com/docs/editor/glob-patterns)と
[検索仕様](https://code.visualstudio.com/docs/editing/codebasics#_advanced-search-options)で確認。
clangdのDB監視対象は [拡張機能の実装](https://github.com/clangd/vscode-clangd/blob/master/src/config-file-watcher.ts)で確認。
今回、稼働中のプロファイル・既存プロジェクトへの配置、VS Codeの実画面での動作確認、ビルドの再実行は行っていません。

## 初回の動作検証（2026-10-11）

このPCの VS Code と拡張機能の設定定義、およびインストール済みツールで確認しました。

| 対象 | 確認内容 | 結果 |
| --- | --- | --- |
| 全設定 | JSON/JSONC構文・レシピ参照・エンジン指定・移植用パス | 正常 |
| 拡張機能 | LaTeX Workshop / clangd / C/C++ / PlatformIO 等の設定キー・列挙値 | 正常 |
| プロファイル生成 | 移植用3種とこのPC用3種を再生成し、前後の内容を比較 | 一致 |
| 既定・部活 | LaTeX Workshop設定が含まれないこと | 正常 |
| 学校用レシピ5種 | upLaTeX / pLaTeX / LuaLaTeX / pdfLaTeX / XeLaTeX | 全てPDF生成成功 |
| 共有 `.latexmkrc` | engineを5種に変更して各文書をビルド | 全てPDF生成成功 |
| 文献処理 | upbibtex / pbibtex / BibTeX / Biber、相互参照の解決 | 正常 |
| 索引 | upLaTeX + makeidx + upmendex | 正常 |
| SyncTeX | 上記の各ビルドで生成 | 正常 |
| 通常清掃 | latexmk -cでPDFとSyncTeXが残ること | 正常 |
| 実際のレポート | E_CdSのTeXとstyを別フォルダへコピーして共有設定でビルド | 2ページPDF生成成功 |
| Windowsパス | 日本語ファイル名・日本語と空白を含むフォルダ | ビルド成功 |
| 部活 clangd | ARMのコンパイルデータベース、C/C++それぞれの標準ヘッダーを検出 | 各0エラー |
| 個人辞書 | 部活用cSpell.userWordsの元ファイルとの比較 | 差分なし |
| 稼働中設定 | 既定の前回LaTeX追記だけ削除。学校・部活プロファイルはバックアップと比較 | 正常 |
| 元共有テンプレート | 学校用・部活用の元設定をバックアップと比較 | 変更なし |

使用環境: TeX Live 2026、latexmk 4.88、LaTeX Workshop 10.19.0、
vscode-clangd 0.6.0、検証用clangd 23.1.0、PlatformIO ARM GCC 14.2.1。

初回の文献テストではTeX LiveがMSYS2のPerlを使用し、BibTeXの検索パスが
`/v/...` になって文献ファイルを見つけられませんでした。
`TEXLIVE_WINDOWS_TRY_EXTERNAL_PERL=0` をビルドツールの環境変数に加え、
TeX Live内蔵Perlで再実行した後の結果を上表に記録しています。

検証用文書・生成物は `.verification/` 内に分離しています。
通常の再生成確認は `scripts/Build-Profiles.ps1` と
`scripts/Validate-Settings.ps1` で実行できます。

検証はWindows上で実施しています。macOS/Linux実機、VS Code内のPDFビューアの操作、
部活のファームウェア全体のビルド・実機書き込みはこの検証には含みません。
