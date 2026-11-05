# VS Code設定の使い方

このフォルダーがあるリポジトリのルートをVS Codeで開くと、共通設定が適用されます。
テーマ・フォント・PDFの表示倍率・AI機能は各自で選べます。

## 編集と保存

| 項目 | 動作 |
| --- | --- |
| 文字コード・改行 | UTF-8・LF。保存時に末尾改行を付ける |
| 自動保存 | 編集後1秒で保存 |
| インデント | 新規ファイルはスペース2個。既存ファイルは自動判定 |
| TeX・BibTeX・Markdown | 折り返しを有効化し、自動整形を無効化 |
| Markdown | 行末スペースによる改行を保持 |
| 補完 | LaTeXのパッケージ・スニペットの補完を有効化 |
| ビルド | TeX保存時に実行。ルート文書名をステータスバーに表示 |
| タスク | 実行前に未保存の変更を保存 |
| Git | 自動fetchを有効化し、親フォルダーの別リポジトリは自動で開かない |

推奨拡張のLaTeX Workshopはビルド・PDF表示に使います。
cSpellは任意のスペルチェックです。

## ビルドと清掃

ビルド・補助ファイルの清掃は、どちらも `scripts/build.lua` を使います。
TeX Liveに含まれる `texlua` から呼び出すため、追加のPythonや外部Perlは不要です。
`.vscode/`・`scripts/`・`config/` を一緒に配置してください。

- 各文書に `.latexmkrc` がなくても、`config/latexmkrc` の共通設定で動きます。
- ルートTeXファイルの先頭の `% !TeX program = ...` でエンジンを選べます。省略時はupLaTeXです。
- 文書と同じフォルダーに `.latexmkrc` がある場合は、その設定を優先し、エンジン指定コメントを読みません。
- コマンド名を直接実行するLaTeX Workshopのマジックコメント機能は無効です。共通処理が許可された5種類のエンジン名だけを読み、latexmkを経由してビルドします。
- `% !TeX root = ...` は分割文書のルート指定として使えます。
- VS Codeでは `--engine=auto` を指定し、個人の `LATEX_ENGINE` に左右されないようにしています。
- Windowsではビルド・清掃の両方でTeX Live内蔵Perlを選びます。

PDFと補助ファイルは各ルート文書の `export/` に出力します。
清掃は `latexmk -c` 相当で、PDFとSyncTeXを残します。自動清掃は行いません。
latexmkは `-norc -r` で選んだ設定だけを読み込み、ユーザーフォルダーの設定には依存しません。

個別設定は用語集・特殊な生成ツールなどが必要な文書向けです。
`config/latexmkrc` を文書のフォルダーに `.latexmkrc` という名前でコピーし、必要な項目を追加できます。
出力先は共通処理の `export/` が優先されます。通常の文書では個別設定を作る必要はありません。

## 一覧・検索・監視

`.vscode/` と主な設定ファイル、各文書の `.latexmkrc`、`export/` の生成物を通常検索から除外します。
`export/` は一覧に表示し、ルートの `.cache/` は隠します。
生成物とキャッシュを監視対象から除外し、設定ファイルの変更は監視します。
設定を検索するときは、検索ビューの「除外設定と無視ファイルを使用」を一時的にオフにしてください。

## 別のPCへ移す

リポジトリ全体をダウンロードし、TeX Live・VS Code・LaTeX Workshopを導入します。
必要なPATH設定とパッケージの説明は [README](../README.md) にあります。
ユーザー名・ドライブ文字・個人用VS Codeプロファイルを固定する設定はありません。

動作確認済みの組合せと未確認の範囲は [動作確認](../README.md#動作確認) を参照してください。

参考: [LaTeX Workshopのビルド仕様](https://github.com/James-Yu/LaTeX-Workshop/wiki/Compile)、
[VS Codeの設定優先順位](https://code.visualstudio.com/docs/configure/settings#_settings-precedence)
