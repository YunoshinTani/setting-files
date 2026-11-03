# Web開発用のVSCode設定

この設定は `web/` 以下で静的サイト、C/C++ CGI、Pythonの公開ツールを管理するワークスペース用です。ワークスペースのルートをVSCodeで開きます。PlatformIO・STM32・HAL用のコンパイラー、規格、診断の例外は使用しません。

## 言語ごとの動作

| 言語 | 字下げ・整形・診断 |
| --- | --- |
| C / C++ | スペース2個、80文字を目安、clangd。掲示板はGNU C11、日記・ファイル便はC++17 |
| HTML / CSS / JavaScript / TypeScript / JSON(C) | VSCode内蔵フォーマッター。Ctrl+Sで整形 |
| Python | スペース4個、Pylanceの基本型チェック。整形拡張は必須にせず保存時整形は無効 |
| Makefile | タブでレシピを記述。保存時整形は無効 |
| Markdown | 折り返して表示。行末のスペースを保持し、保存時整形は無効 |

自動保存は1秒後、タスク実行前にも保存します。遅延自動保存では整形せず、明示的なCtrl+Sで言語別の整形を行います。テーマ・フォント・ターミナルの好みはプロファイル側で管理します。

言語別設定は `[c]`、`[cpp]` のように個別に記述しています。複数言語の結合キーより、プロファイル側の単一言語設定が優先される問題を避けるためです。[VSCodeの設定優先順位](https://code.visualstudio.com/docs/configure/settings#_settings-precedence)

## clangdを初期化・更新する

必要なものはPython 3.9以降、GCC、clangd拡張です。このPCではclangd 23.1.0で診断・整形を確認しています。推奨拡張は `extensions.json` にまとめています。HTML・CSS・JavaScriptの整形用に追加の拡張を入れる必要はありません。

ワークスペース直下で次を実行するか、「Tasks: Run Task」→ **「Web開発: clangd設定を更新」** を実行します。

```powershell
python web/tools/compile_commands.py
```

次のタイミングで再実行してください。

- この設定を新しいPC・別の場所へコピーしたとき
- C/C++のソースファイルを追加・削除したとき
- MakefileのCPPFLAGS・CFLAGS・CXXFLAGSを変更したとき
- MSYS2/GCCを更新したとき

生成処理はMakefileのフラグとGCCの実際の標準ヘッダーの検索先を読み、ルートの `compile_commands.json` だけを更新します。現在はCGI 8本と共通C++テスト1本が対象です。バイナリのビルド・公開・サーバーへの接続は行いません。Makefile中の変数展開を含む複雑なフラグは黙って無視せず、エラーにします。

Windowsでは既定で `C:/msys64/usr/bin/gcc.exe` と `g++.exe` を使用します。CGIに必要なPOSIX APIがあるため、UCRT/MinGW版のGCCへ自動的に切り替えることはしません。MSYS2を別の場所に置いている場合は、`MSYS2_ROOT` 環境変数か `--cc` / `--cxx` で指定します。

```powershell
python web/tools/compile_commands.py --cc D:/msys64/usr/bin/gcc.exe --cxx D:/msys64/usr/bin/g++.exe
```

GCCが返す `/usr/include` などのMSYSパスはWindowsの絶対パスへ変換してDBへ保存します。これによりWindows版clangdでも標準ヘッダーを見つけられます。`--query-driver` にARM用コンパイラーや広い実行許可を追加する必要はありません。[clangdの標準ヘッダーの仕様](https://clangd.llvm.org/guides/system-headers)

Linux/WSLで編集する場合は、そのLinux環境で `python3 web/tools/compile_commands.py` を再実行します。Windows用に生成したDBをそのまま使わないでください。clangdの実行ファイルの個人別パスはこの共有設定には固定せず、既存のプロファイル設定または拡張機能のインストールを使用します。

設定を反映後、診断が更新されない場合はコマンドパレットで **「clangd: Restart language server」** を実行します。古い日記専用の `web/diary/compile_commands.json` は廃止し、ルートのDBへ統一しました。

`.clangd` はプロジェクトの実装へbugprone・静的解析・performanceのチェックを適用します。外部のSQLiteヘッダーと生成ヘッダーへ追加lintをかけたり、ロボット用の命名やHAL規則を要求したりしません。Cとして使用する共通セキュリティヘッダーは単独でもC11として解析します。

`.clang-format` はGoogleスタイルを基準に、C++17・スペース2個・LF・80文字を指定しています。日本語コメントの段落の折り返しは変更しません。今回、既存のC/C++ソースを一括整形することはしていません。

## 検証・公開と生成物

従来の公開・復元・Web検証タスクを引き続き使います。clangdのWindows上での解析は編集支援であり、本番用CGIのビルドはPi、CGIの回帰テストは既存のWSL環境で行います。Makefile Toolsによる自動構成は止め、Windowsの既定GCCでCGIを自動ビルドしないようにしています。

キャッシュ・公開用スナップショット・Pythonキャッシュ・コンパイルDBはエクスプローラーから隠します。CGIのbuildディレクトリは確認用に表示しますが、生成物・実データ・node_modulesは監視・検索から除外します。ルートのコンパイルDBはclangdの更新検知のため監視に残します。

共通JavaScript・CSSは `web/common/public/` を編集します。自動で複製される各サイトのコピーと縁日のビルド済み `public/` は通常検索から除外します。設定ファイルや公開処理のPythonスクリプトは検索対象に残します。

## 配布用に反映するファイル

`V:/7_script/vscode/projects/web` へ、次の相対パスを保って反映します。

```text
.vscode/settings.json
.vscode/tasks.json
.vscode/extensions.json
.vscode/README.md
.clangd
.clang-format
web/tools/compile_commands.py
```

`compile_commands.json` はPC・配置先ごとの生成物なので配布せず、コピー先で生成します。`sftp.json`、SSHキー、実データ、実行バイナリ、公開スナップショットも配布対象に含めません。公開タスクを使うには、このWebプロジェクトの `web/tools/publish.py`・`deploy.json` 等が別途必要です。このフォルダーは設定一式の保管先であり、サイト本体を含む新規プロジェクト生成ツールではありません。
