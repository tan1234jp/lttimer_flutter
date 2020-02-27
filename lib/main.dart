import 'package:flutter/material.dart';
import 'package:lttimer/ui/header.dart';
import 'package:lttimer/ui/periodic_timer.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import 'ui/periodic_timer.dart';

/// 関数オブジェクトの定義
typedef ButtonEventFunc = void Function();

///
/// エントリポイント
void main() => runApp(LTTimerApp());

///
/// アプリケーションメインクラス
class LTTimerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // マテリアルデザインを使用
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 右上の「DEBUG」表示を無効化
      theme: ThemeData(
        // テーマ指定
        primarySwatch: Colors.lightBlue,
      ),
      home: ChangeNotifierProvider(
        // タイマプロバイダの初期化
        create: (context) => PeriodicTimer(5 * 60 * 1000),
        child: _LTTimerApp(),
      ),
    );
  }
}

///
/// アプリケーションメイン非公開クラス
class _LTTimerApp extends StatelessWidget {
  ///
  /// ボタンイベント定義
  Tuple3<ButtonEventFunc, IconData, String> _buttonEventHandler(
      PeriodicTimer timer) {
    ButtonEventFunc _func1;

    // タイマ状態によりボタン押下時の処理を分岐する
    switch (timer.runningState) {
      case TimerState.ready: // タイマ開始準備完了
        _func1 = timer.start; // ボタン押下時にstart()を呼び出す
        return Tuple3(_func1, Icons.play_arrow, 'START');
      case TimerState.running: // タイマ実行中
        return Tuple3(_func1, Icons.stop, '');
      default: // その他(タイマ終了)
        _func1 = timer.reset; // ボタン押下時にreset()を呼び出す
        return Tuple3(_func1, Icons.refresh, 'RESET');
    }
  }

  ///
  /// ボタンウィジェット
  Widget _createButton(PeriodicTimer timer) {
    //　タイマが実行中の時は、空のコンテナを返す(=ボタン非表示)
    if (timer.runningState == TimerState.running) {
      return Container();
    }

    // ボタンウィジェットを返す
    return RaisedButton.icon(
      // ボタン押下処理
      onPressed: _buttonEventHandler(timer).item1 == null
          ? null
          : () => _buttonEventHandler(timer).item1(),
      // ボタン内に表示するアイコン定義
      icon: Icon(
        _buttonEventHandler(timer).item2,
      ),
      // ボタン内に表示する文字列
      label: Text(_buttonEventHandler(timer).item3),
      // ボタン色（背景色）
      color: Colors.green,
      // ボタン色（アイコン・文字列）
      textColor: Colors.white,
    );
  }

  // アプリケーションのUIを生成する
  // @param context BuildContext
  @override
  Widget build(BuildContext context) {
    // PeriodicTimerクラスをシグナルに持ったUIを返す
    return Consumer<PeriodicTimer>(
      builder: (context, timer, _) {
        return Scaffold(
          // 全体の背景色を定義
          // 残り時間が60秒未満 → 黄色
          // 上記以外 → デフォルト色
          backgroundColor: timer.time < 60000
              ? Colors.yellowAccent
              : Theme.of(context).scaffoldBackgroundColor,
          // アプリケーションバーを表示
          appBar: AppHeader(),
          // アプリケーション本体のUI定義（セーフエリア対応）
          body: SafeArea(
            // 横向きにウィジェットを配置
            child: Column(
              // ウィジェットの間は適度な間隔をあける
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              // UI定義
              children: <Widget>[
                // タイマ表示領域の設定
                Text(
                  timer.toString(),
                  style: TextStyle(
                    fontFamily: 'DSEG14Classic-Regular',
                    fontSize: 60,
                    // 残り時間が60秒未満 → 赤
                    // 条件以外 → デフォルト色
                    color: timer.time < 60000
                        ? Colors.red
                        : Theme.of(context).primaryTextTheme.bodyText1.color,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _createButton(timer),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
