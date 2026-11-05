# 学校用LaTeX環境

`.vscode/`・`scripts/`・`config/` をレポートの親フォルダーへまとめてコピーします。
TeX Live、VS Code、LaTeX Workshopを用意し、親フォルダーをVS Codeで開いて使います。
既存のファイルがある場合は、必要な設定を統合してください。

TeX Liveの導入後はVS Codeを起動し直します。
独自の場所へ導入した場合は、`texlua`・`latexmk`・TeXエンジンを実行できるPATHが必要です。
学校指定のスタイルは文書と一緒に用意し、追加のパッケージはTeX Liveマネージャから導入してください。

## レポートを作る

新しいフォルダーにTeXファイルを保存するだけで使えます。
各文書に `.latexmkrc` を配置する必要はありません。

```tex
\documentclass[uplatex,dvipdfmx,a4paper]{jsarticle}
\begin{document}
\section{目的}
ここにレポートを書きます。
\end{document}
```

保存するとビルドし、TeXファイルと同じフォルダーの `export/` にPDFを生成します。
学校指定のスタイル・画像・文献がある場合は、文書と一緒に置いてください。

## エンジンを変える

省略時はupLaTeXです。別のエンジンを使う場合はTeX先頭に1行記載します。

```tex
% !TeX program = lualatex
\documentclass{ltjsarticle}
```

値は `uplatex`・`platex`・`lualatex`・`pdflatex`・`xelatex` です。
文書クラス・パッケージも、そのエンジンに対応する必要があります。
エンジンを変える前に **LaTeX Workshop: Clean up auxiliary files** を実行してください。

既存の `.latexmkrc` が文書と同じフォルダーにある場合は、その個別設定を優先します。
分割本文では `% !TeX root = ../main.tex` などを使ってルート文書を指定できます。

## ターミナルから使う

```sh
texlua scripts/build.lua report/main.tex
texlua scripts/build.lua --clean report/main.tex
texlua scripts/build.lua --engine=lualatex report/main.tex
```

## 動作確認

共通のビルド処理はWindows / TeX Live 2026で、5エンジン・8通りの文書、
個別設定なしの新規文書、既存の個別設定、清掃後の再ビルドを確認しています。
別PC実機・macOS / Linux実機での実行と、VS Code画面上の操作は未確認です。
導入後はビルド・PDF表示・分割本文のルート検出・SyncTeXを確認してください。

設定と個別設定の使い方は [.vscode/README.md](.vscode/README.md) を参照してください。
