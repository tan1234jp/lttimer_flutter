import 'package:flutter/material.dart';
import 'package:lttimer/ui/countdown_timer.dart';

///
/// エントリポイント
void main() => runApp(LTTimerApp());

///
/// アプリケーションメインクラス
class LTTimerApp extends StatelessWidget {
  ///
  /// UIを生成する
  /// @param context: BuildContext
  /// @return 生成されたUIウィジェットオブジェクト
  @override
  Widget build(BuildContext context) {
    // マテリアルデザインを使用
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 右上の「DEBUG」表示を無効化
      theme: ThemeData(
        // テーマ指定
        primarySwatch: Colors.lightBlue,
      ),
      home: CountDownTimer(Duration(minutes: 5, seconds: 0)),
    );
  }
}
