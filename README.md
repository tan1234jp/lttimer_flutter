# LT-Timer for Flutter

Lightning-Talk Timer Application.

Demonstration page is [here](https://tan1234jp.github.io/).

## インストール・設定

[公式ページ](https://flutter.dev/docs/get-started/install)の手順に従ってインストール・設定してください。なお、web applicationのビルドには追加で[こちら](https://flutter.dev/docs/get-started/web)の設定が必要となります。

### ビルドおよび実行方法

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
---

## Getting Started

- [Get the Flutter SDK](https://flutter.dev/docs/get-started/install)
- If you want to build a web application, you have to get the latest version of the Flatter SDK from the beta channel and enable web support. Setting up is [here](https://flutter.dev/docs/get-started/web).

## Build and Run

- Get the repository from [Github](https://github.com/tan1234jp/lttimer_flutter) or [download ZIP archive](https://github.com/tan1234jp/lttimer_flutter/archive/master.zip) and extract to your computer.

  ```sh
  $ git clone https://github.com/tan1234jp/lttimer_flutter.git
  ```

- Update package libraries.

  ```sh
  $ cd <project directory name here>
  $ flutter package pub
  ```

- Build projects.

  ```sh
  $ flutter build <apk/ios/web>
  ```

------

## Running information (11-Mar-2020)

### Flatter & Dart version

| SDK      | Version              |
|----------|----------------------|
| Flatter  | 1.14.6 (Channel beta)|
| Dart     | 2.8.0                |

### Desktop

| Browser             | Version                       | Condition  |
| ------------------- | ----------------------------- | ---------- |
| Chrome              | 80.0.3987.132(official 64bit) | RUNNING    |
| Firefox             | 74.0(64bit)                   | RUNNING    |
| Internet Explorer   | 11.535.18362.0(11.0.165)      | NOT RUNNING|
| Microsoft Edge      | 44.18362.449.0(HTML 18.18362) | RUNNING    |
| Safari (MacOS ONLY) |                               | NOT TESTED |
|                     |                               |            |

### Mobile(Native)

| OS      | Version           | Condition  |
| ------- | ----------------- | ---------- |
| Android | 8.1               | RUNNING    |
| Android | 9.0               | RUNNING    |
| Android | 10.0              | RUNNING    |
| iOS     | 13.3              | RUNNING    |
| iOS     | 13.3.1            | NOT RUNNING<sup>[1](#footnote1)</sup> |
| iPadOS  | 13.3              | NOT TESTED |
| iPadOS  | 13.3.1            | NOT RUNNING<sup>[1](#footnote1)</sup> |
|         |                   |            |

<a name="footnote1">1</a>: Running new app on actual iOS/iPad OS(13.3.1) device crashes on startup. See [flutter issues](https://github.com/flutter/flutter/issues/49504).

### Mobile(Web)

| Browser | Version | Condition  |
| ------- | ------- | ---------- |
| Chrome  |         | RUNNING<sup>[2](#footnote2)</sup> |
| Safari  |         | RUNNING<sup>[2](#footnote2)</sup> |
|         |         |            |

<a name="footnote2">2</a>: Vibration not supported.
