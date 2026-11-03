# VS Code 共有設定の運用

プロジェクトのルートフォルダーを VS Code で開き、推奨拡張をインストールします。
PlatformIO の初回セットアップ完了後、タスクを利用できます。
このひな型の `src/main.cc` は空です。ビルド・書き込みを行う前に `main` 関数を実装してください。

## ビルドと再ビルド

「ターミナル → タスクの実行」から次を選べます。

| タスク | 動作 |
| --- | --- |
| Nbed: ビルド（既定環境） | `default_envs` をビルド。`Ctrl+Shift+B` の既定タスク |
| Nbed: 書き込み（既定環境） | ビルドして実機へ書き込み |
| Nbed: clangd用ビルド情報を更新（既定環境） | コンパイルせずコンパイルDBを生成 |
| Nbed: クリーン（既定環境） | PlatformIO の通常クリーン |
| Nbed: 生成物とキャッシュを全削除 | 全環境のビルド結果・キャッシュ・生成DBを削除 |
| Nbed: 完全再ビルド（既定環境） | 全削除が成功した後に既定環境をビルド |

対象環境は `platformio.ini` の `[platformio] default_envs` で管理します。
初期値は `nucleo_f446re` です。環境名を変更するときはここも更新します。
タスク内に環境名を重複して記載する必要はありません。

完全削除の対象は、このプロジェクトの `build/`、`.cache/`、旧設定の `.pio/build/`、
ルートの `compile_commands.json` と `compile_commands.json.tmp.*` です。
全環境のビルド結果を消しますが、再ビルドするのは `default_envs` の環境です。
`src/build/` などの開発用フォルダーと `.pio/libdeps/` の依存ライブラリは保持します。
依存パッケージの再インストールは行いません。ビルドやモニターの終了後に実行してください。
`build_dir` や `build_cache_dir` を変更する場合は `clean.py` の固定パスも更新します。

タスクは PlatformIO 標準の `${userHome}/.platformio/penv/` を直接使い、
個人の PATH やシェルの種類に依存しません。Windows は `Scripts/`、
macOS/Linux は `bin/` を利用します。Core の保存先を変更した環境では
`tasks.json` の各 `command` / `windows.command` を実際の保存先に合わせてください。

## 共有する設定

`V:/7_script/vscode/sources/common.settings.jsonc`、`sources/robotics.overrides.jsonc`、
`projects/robotics/.vscode/settings.json` を基に、このひな型向けに校正しています。
確定した設定一式は `V:/7_script/vscode/projects/robotics/` にも反映しています。
共通の編集動作は `sources/common.settings.jsonc`、部活用の整形・TODO検索は
`sources/robotics.overrides.jsonc` に反映し、配布用・このPC用のプロファイルを生成します。

| 設定キー | 共有する値・動作 |
| --- | --- |
| `files.autoSave` / `files.autoSaveDelay` | `afterDelay` / 1000 ms |
| `editor.tabSize` / `editor.insertSpaces` / `editor.detectIndentation` | 基本値はスペース2個。既存ファイルではインデントを自動判定。C/C++ にも同じ値を明示 |
| `editor.linkedEditing` / `editor.autoIndentOnPaste` | 対応言語の連動編集・貼り付け時のインデント調整を有効化 |
| `editor.autoIndentOnPasteWithinString` | 無効。文字列内での貼り付けに自動字下げを適用しない |
| `editor.renderWhitespace` | 空白をすべて表示 |
| `editor.guides.indentation` / `editor.guides.bracketPairs` | インデント・括弧のガイドを表示 |
| `editor.semanticHighlighting.enabled` | 意味に応じた強調表示を有効化 |
| `[c]` / `[cpp]` の `editor.rulers` | `.clang-format` の行幅に合わせて80文字の目安線を表示 |
| `editor.unicodeHighlight.allowedLocales` | 日本語 `ja` を許可。利用者のOS・表示言語だけに依存しない |
| `editor.quickSuggestions` | 通常箇所・文字列は有効、コメント内は無効 |
| `editor.formatOnSave` / `editor.formatOnPaste` | 全言語の基本値は無効。C/C++ では両方有効。Markdown では両方無効を明示 |
| `[c]` / `[cpp]` の `editor.formatOnSaveMode` | `file`。保存時は変更行だけでなくファイル全体を整形 |
| `[c]` / `[cpp]` の `editor.formatOnPaste` | 既存の保存時整形に加え、貼り付け時も clangd で整形 |
| `[markdown]` の `editor.wordWrap` | 折り返しを有効化 |
| `[markdown]` の `editor.quickSuggestions` | Markdown では自動候補を無効化 |
| `[markdown]` の `editor.unicodeHighlight.ambiguousCharacters` / `editor.unicodeHighlight.invisibleCharacters` | 有効。日本語は許可し、その他の紛らわしい文字・不可視文字の検知を維持 |
| `[markdown]` の `files.trimTrailingWhitespace` | 無効。行末スペース2個による改行を保持 |
| `[markdown]` の `diffEditor.ignoreTrimWhitespace` | 空白の違いも差分に表示 |
| `platformio-ide.disablePIOHomeStartup` / `platformio-ide.autoOpenPlatformIOIniFile` | PIO Home・設定ファイルの自動表示を停止 |
| `task.saveBeforeRun` | `always`。ビルドなどのタスク開始前に保存 |
| `git.autofetch` / `git.openRepositoryInParentFolders` | 自動 fetch を有効化・親フォルダーのリポジトリを自動で開かない |
| `todo-tree.tree.showBadges` / `todo-tree.tree.showCountsInTree` | TODO のバッジ・件数を表示 |
| `todo-tree.filtering.useBuiltInExcludes` | `search excludes`。検索除外をTODOの検索にも適用 |
| `files.exclude` | ルートの `.cache` と生成DBを追加で隠す |
| `files.watcherExclude` / `search.exclude` | 生成物の除外をルート直下に限定。検索ではルートの `.vscode/`・`.clangd`・`.clang-format` も除外 |

`afterDelay` の自動保存は VS Code の仕様で保存時整形を実行しません。
C/C++ の整形を確定するには `Ctrl+S` または「ドキュメントのフォーマット」を使います。
テーマ・フォント・画面倍率・ターミナル・AI・個人辞書・確認ダイアログの省略は個人設定に残します。

既存ファイルの自動判定は、入力時のタブ幅・スペース挿入方法を決める設定です。
読み込むだけでファイル全体を書き換えることはありません。
C/C++ の保存・貼り付け時整形は別に `.clang-format` に従います。
そのため、外部コードの書式をそのまま保って編集する場合は、対象プロジェクト側で
該当言語の自動整形を無効にするか、外部コード側の `.clang-format` を用意します。
プロジェクトの `[c]` / `[cpp]` の指定は、同じ言語の個人設定より優先されます。

文字列や文書の意味を変えないため、全言語に対する行末空白・末尾改行の自動整理は追加していません。
C/C++ の末尾改行などは既存の `.clang-format` が担当します。

## 校正で変更・追加した項目（2026-10-18）

| 分類 | 項目 | 理由 |
| --- | --- | --- |
| 変更 | `editor.detectIndentation` を全体・C・C++で `false` → `true` | 外部ファイルの既存インデントを尊重。新規ファイルの基本値はスペース2個を維持 |
| 移動 | 80文字の `editor.rulers` を全体から C/C++ へ | 行幅規約がある言語に限定し、文書や他言語には強制しない |
| 変更・追加 | Markdown の Unicode 警告を有効化し、全体に `allowedLocales: { "ja": true }` を追加 | 日本語を許可しつつ、文字検知を全面的に無効にしない |
| 追加 | `editor.autoIndentOnPasteWithinString: false` | 文字列内への貼り付けで自動字下げが内容を変えるのを防ぐ |
| 追加 | C/C++ の `editor.formatOnSaveMode: "file"` | 保存時整形の範囲が個人設定によって変わらないようにする |
| 追加 | Markdown の `files.trimTrailingWhitespace: false` と自動整形の無効化 | 行末空白と手書きの文書レイアウトを保持。言語別の個人設定より優先させる |
| 追加 | `task.saveBeforeRun: "always"` | 自動保存を待たずにビルドした場合も編集内容を保存する |
| 追加 | `todo-tree.filtering.useBuiltInExcludes: "search excludes"` | 生成物・依存ライブラリ内のTODOを通常検索と同じ範囲で除外 |
| 追加 | `search.exclude` の `.vscode/**: true` | 通常のコード検索にエディター設定・タスク・説明書が混ざらないようにする |
| 追加 | `search.exclude` の `.clangd: true` / `.clang-format: true` | 通常のコード検索に診断・整形規約の設定項目が混ざらないようにする |
| コメント修正 | 非標準Core保存先での `clangd.arguments` の調整場所 | ワークスペースの値は個人設定では上書きできないため、プロジェクト側の調整として説明 |

自動保存の `afterDelay` / 1000 ms、C/C++ の clangd 整形、UTF-8 / LF、
検索・監視のルート限定除外、Git・PlatformIO の既存設定は維持しました。
拡張の追加インストールを必要とする設定は増やしていません。

## 除外範囲

### PlatformIOスクリプトのPython解析

`compiledb.py` は PlatformIO/SCons の実行環境で動くスクリプトです。
SConsはPlatformIO専用パッケージから読み込まれ、`Import` と `env` は実行時に提供されます。
通常のPython環境を解析するPylanceからは見えないため、この3箇所だけに理由付きの
`pyright: ignore[reportMissingImports]` / `pyright: ignore[reportUndefinedVariable]` を付けています。
他のPythonコードの診断は維持し、PC固有の検索パスは追加していません。

### 一覧・検索・Git

`.gitignore` の `/build/` は最初からルート直下のみです。
`src/build/` を除外するのは `build/` のように先頭の `/` がない指定です。
今回、Python キャッシュやアーカイブの規則にも先頭の `/` を付けました。
サブディレクトリのファイルは、別途その階層の `.gitignore` などで指定しない限り追跡されます。
Git の個人設定・グローバル除外は別途適用されます。

VS Code の除外パターンでは `build/**` を使い、先頭に `**/` を付けません。
ルートの `compile_commands.json` は検索・一覧から隠しますが、clangd が更新を検知できるよう監視対象に残します。
ルートの `.vscode/`・`.clangd`・`.clang-format` は検索から除外しますが、エクスプローラーへの表示と変更の監視は続けます。
検索ビューの「除外設定と無視ファイルを使用」を一時的にオフにすれば、設定・タスク・説明書も検索できます。
この検索除外は TODO Tree にも適用されます。
`src/.vscode/` などの同名フォルダーは、このルート限定の指定では除外しません。
`platformio.ini` など、ルートの他の設定ファイルは検索対象に残しています。

## 推奨拡張の考え方

`extensions.json` の選定は維持しています。
PlatformIO・clangd・C/C++ が開発の中心です。C/C++ 拡張は PlatformIO の依存でもあり、
IntelliSense を無効にした既存設定のままデバッグ機能を利用できます。
`unwantedRecommendations` は推奨を抑制する設定で、インストールを禁止するものではありません。

Teleplot は計測時、TODO Tree・Error Lens は編集支援、Git Graph・GitHub Pull Requests は
Git 作業、Markdown 関連は文書作成に役立ちます。テーマは各自で利用を選べます。
GitHub Markdown Preview は複数拡張を導入するパックなので、軽量化するなら
必要なプレビュー拡張だけを個別に選ぶ方法があります。

参考:

- [PlatformIO: default_envs](https://docs.platformio.org/en/latest/projectconf/sections/platformio/options/generic/default_envs.html)
- [Git: gitignore](https://git-scm.com/docs/gitignore)
- [GitHub Markdown Preview](https://marketplace.visualstudio.com/items?itemName=bierner.github-markdown-preview)
- [VS Code: インデントの自動判定・保存・整形](https://code.visualstudio.com/docs/editing/codebasics)
- [VS Code: 言語別設定と優先順位](https://code.visualstudio.com/docs/configure/settings#_settings-precedence)
- [VS Code: Markdown の行末空白](https://code.visualstudio.com/docs/languages/markdown#_keep-trailing-whitespace-in-order-to-create-line-breaks)
- [VS Code: Unicode 文字の設定定義](https://github.com/microsoft/vscode/blob/main/src/vs/editor/common/config/editorOptions.ts)
- [TODO Tree: 検索除外の設定](https://github.com/Gruntfuggly/todo-tree#filtering)

## 確認結果（2026-10-18）

JSONC の読み込み、タスクの参照関係、実行ファイルの存在、Git の除外範囲を確認しました。
一時プロジェクトで削除処理を実行し、入れ子の同名フォルダーと依存ライブラリが保持されること、
プロジェクト外を参照するジャンクションを削除前に拒否することを確認しました。
同じ設定と最小限の `main` を使う別の一時プロジェクトでは、コンパイルDB生成と完全再ビルドが成功しました。
ひな型そのもののビルドは、空の `src/main.cc` による `undefined reference to main` で失敗します。
実機への書き込みとデバッグは未確認です。

共有設定の校正では、インストール済みの VS Code 1.142.0 の設定登録と、
各拡張の設定定義を照合しました。JSONC の読み込み、設定キーの存在、
拡張設定の型・選択肢・非推奨指定を確認しています。
校正段階の変更対象は `settings.json` とこの説明書だけです。
その後の確定版反映では、配布元の `projects/robotics/` に設定一式を同期し、
共通ソース・部活用差分からプロファイルを再生成しています。
ひな型の clangd 関連・ビルドタスク・拡張機能一覧の内容は維持しています。
この校正によるエディター操作全体の実機確認は行っていません。
