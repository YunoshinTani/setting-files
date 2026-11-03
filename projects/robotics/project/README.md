# 部活用の確定設定一式

`V:/2_robotics/11_template/template-nbed-project` で確定したNbedプロジェクト設定の配布元です。
ファームウェアのソース・生成物・PC固有のデバッグ設定は含みません。

## 配布するファイル

- `.vscode/settings.json`: コード編集・自動保存・ツール動作の共有設定
- `.vscode/tasks.json`: 既定環境のビルド・書き込み・コンパイルDB生成・通常クリーン・全削除・完全再ビルド
- `.vscode/clean.py`: ルートの生成物だけを削除する処理
- `.vscode/extensions.json`: 推奨拡張
- `.vscode/README.md`: 設定項目・タスク・除外範囲の詳しい説明
- `.clangd` / `.clang-format`: 校正済みの診断・整形設定
- `.gitignore`: プロジェクトルートを基準とする除外規則
- `platformio.ini` / `compiledb.py`: NUCLEO-F446REの初期構成・コンパイルDB生成

## 適用

新しいプロジェクトには、ひな型 `template-nbed-project` を使います。
この配布フォルダーの設定を既存プロジェクトへ統合する場合は、ボード、環境名、依存ライブラリ、
追加スクリプトなどの独自設定を維持して `platformio.ini` を調整してください。
`extra_scripts = pre:compiledb.py` が必要です。既存のDB生成処理との二重登録は避けます。
初期の `default_envs` は `nucleo_f446re` です。

`src/main.cc` などのアプリケーションソースは、利用側のプロジェクトに用意します。
PlatformIO拡張の初回セットアップ完了後にビルドタスクを利用できます。

テーマ・フォント・ターミナル・画面倍率などは個人設定です。
個人用の共通動作は `sources/common.settings.jsonc`、部活用のツール差分は
`sources/robotics.overrides.jsonc` からプロファイルへ生成します。
共有設定の詳細と検索除外の一時解除方法は [.vscode/README.md](.vscode/README.md) を参照してください。

## コンパイルDBと完全再ビルド

通常ビルドでプロジェクトルートの `compile_commands.json` を更新します。
DBだけ必要な場合は「Nbed: clangd用ビルド情報を更新（既定環境）」を使います。
別PCから生成済みDBを持ち込まず、そのPCで再生成してください。

完全再ビルドは全環境の `build/`、`.cache/`、旧 `.pio/build/` とルートの生成DBを消去し、
`default_envs` をビルドします。`.pio/libdeps/` と `src/build/` などは保持します。
出力先を変更する場合は `clean.py` の固定パスも合わせて変更してください。

PlatformIO Coreの保存先が標準と異なる場合は、プロジェクト側で
`tasks.json` の実行ファイルと `settings.json` の `clangd.arguments` を実際の保存先に合わせます。
