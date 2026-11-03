# このPCだけの設定

`default.local.jsonc`、`school.local.jsonc`、`robotics.local.jsonc` を必要に応じて
このフォルダに作成します。各ファイルは通常の settings.json と同じ形式です。
`Build-Profiles.ps1 -IncludeMachine` で
「共通 → プロファイル差分 → このPCの差分」の順で適用され、`profiles-local/` に出力します。
引数なしの生成結果 `profiles/` にはPC固有のパスを入れません。

`window.newWindowProfile: "robotics"` も、このPCにあるプロファイル名への依存として
各 `*.local.jsonc` に分離しています。配布用 `profiles/` には含めません。
別PCで新規ウィンドウのプロファイルを固定したい場合は、そのPCに実在する名前を指定します。

このPC用ファイルには既存の clangd.path を分離して保存済みです。
別PCでは clangd を PATH にインストールするか、各プロファイルで拡張機能の
`clangd: Download language server` を実行すると、そのPCの実行ファイルが設定されます。
バージョン付きの clangd.path は共通ソースには入れません。

PowerShell 7 がないPCでは VS Code が検出した Windows PowerShell を使います。
プロファイル生成スクリプトには PowerShell 7 が必要です。
生成済みの settings.json を利用するだけなら PowerShell 7 は不要です。

以前の `dart.flutterSdkPath` は別ユーザーのパスを指していたためテンプレートから除外。
Flutter が必要なプロファイルだけに、このPCの実在する SDK パスを追加してください。
以前の todo-tree.ripgrep.ripgrep もPC固有なので必要時だけ追加します。

SSH 接続先のOS指定など個人的な接続情報も、このPC用のファイルで管理します。
このフォルダは共有・Git登録しません。
