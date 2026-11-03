# Webプロジェクトの共有設定

`V:/5_server/tani-server1-dev` で検証したWeb開発設定です。

- `.vscode/`: 言語別の編集・整形・診断、公開・検証・clangd更新タスク、推奨拡張、運用説明
- `.clangd` / `.clang-format`: C/C++ CGI向けの解析と整形
- `web/tools/compile_commands.py`: 配置先のMakefileとGCCからclangd用DBを生成

配置先プロジェクトへ相対パスを保ってコピーし、`python web/tools/compile_commands.py` を実行してください。
サイト本体、公開スクリプト一式、接続設定、GCC、Python、clangdは同梱していません。
既存の `.vscode/tasks.json` に独自タスクがある場合は内容を確認して統合してください。

設定の理由と実行条件は [.vscode/README.md](.vscode/README.md) に記載しています。
`compile_commands.json` はPC・場所ごとに異なるため含めていません。

2026-11-03: clangd 23.1.0で9翻訳単位と主要共通ヘッダーの解析、C/C++のLSP整形を確認済み。
