# LT-Timer for Flutter

Lightning-Talk Timer Application.

[Web版のデモページはこちら。](https://tan1234jp.github.io/)

## インストール・設定

[公式ページ](https://flutter.dev/docs/get-started/install)の手順に従ってインストール・設定してください。なお、web applicationのビルドには[追加の設定が必要](https://flutter.dev/docs/get-started/web)となります。

## ビルドおよび実行方法

- [Github](https://github.com/tan1234jp/lttimer_flutter)からリポジトリをクローン、または[ZIPファイル](https://github.com/tan1234jp/lttimer_flutter/archive/master.zip)をダウンロードし、解凍します。

  ```sh
  $ git clone https://github.com/tan1234jp/lttimer_flutter.git
  ```

- プロジェクトで使用しているパッケージを更新します。

  ```sh
  $ cd <プロジェクト名>
  $ flutter package pub
  ```

- プロジェクトをビルドします。

  ```sh
  $ flutter build <apk/ios/web>
  ```

------

## 動作確認 (2020-04-01)

### 確認を行ったFlatterおよびDartのバージョン

| SDK      | Version              |
|----------|----------------------|
| Flatter  | 1.15.7 (Channel beta)|
| Dart     | 2.8.0-dev.12.0       |

### デスクトップ(PWA)

| ブラウザ名          | バージョン                    | 動作状況   |
| ------------------- | ----------------------------- | ---------- |
| Chrome              | 80.0.3987.149(official 64bit) | 動作可     |
| Firefox             | 74.0(64bit)                   | 動作可     |
| Internet Explorer   | 11.535.18362.0(11.0.165)      | 動作不可   |
| Microsoft Edge      | 44.18362.449.0(HTML 18.18363) | 動作可     |
| Safari (macOSのみ)  |                               | 動作可     |
|                     |                               |            |

### 携帯端末(アプリ)

| OS      | バージョン        | 動作状況   |
| ------- | ----------------- | ---------- |
| Android | 8.1               | 動作可     |
| Android | 9.0               | 動作可     |
| Android | 10.0              | 動作可     |
| iOS     | 13.3              | 動作可     |
| iOS     | 13.3.1            | 確認不可<sup>[1](#footnote1)</sup> |
| iOS     | 13.4              | 動作可     |
| iPadOS  | 13.3              | 未確認     |
| iPadOS  | 13.3.1            | 確認不可<sup>[1](#footnote1)</sup> |
| iPadOS  | 13.4              | 確認中     |
|         |                   |            |

<a name="footnote1">1</a>: iOS/iPad OS(13.3.1)の実機では起動時にクラッシュする不具合あり。詳しくは[こちら](https://github.com/flutter/flutter/issues/49504)。

### 携帯端末(PWA)

| ブラウザ名 | バージョン | 動作状況   |
| ------- | ------- | ---------- |
| Chrome  |         | 一部動作<sup>[2](#footnote2)</sup> |
| Safari  |         | 一部動作<sup>[2](#footnote2)</sup> |
|         |         |            |

<a name="footnote2">2</a>: タイマー終了時のバイブレーションが動作しません。
