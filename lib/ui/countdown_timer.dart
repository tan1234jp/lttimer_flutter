import 'package:flutter/material.dart';
import 'package:lttimer/ui/header.dart';
import 'package:lttimer/ui/timer_painter.dart';

///
/// カウントダウンタイマクラス
class CountDownTimer extends StatefulWidget {
  ///
  /// コンストラクタ
  /// @param duration タイマ初期時間
  CountDownTimer(this.duration);

  /// タイマ初期時間
  final Duration duration;

  ///
  /// StatefulWidgetオブジェクトを生成する
  @override
  _CountDownTimer createState() => _CountDownTimer(duration);
}

///
/// カウントダウンタイマ 内部クラス
class _CountDownTimer extends State<CountDownTimer>
    with TickerProviderStateMixin {
  ///
  /// コンストラクタ
  /// @param duration タイマ初期時間
  _CountDownTimer(this.duration);

  /// タイマ初期時間
  final Duration duration;
  // アニメーションコントロール
  AnimationController animationController;

  ///
  /// 残り時間を「99:99.9」形式の文字列で返す
  String get timerString {
    Duration duration =
        animationController.duration * animationController.value;
    return '${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}.${((duration.inMilliseconds % 1000) ~/ 100).toString()}';
  }

  ///
  /// アニメーションの初期設定を行う
  @override
  void initState() {
    super.initState();
    // アニメーションのインスタンスを生成する（5分で終了）
    animationController = AnimationController(vsync: this, duration: duration);
    // 初期値を1.0(100%)に設定
    animationController.value = 1.0;
  }

  ///
  /// UIを生成する
  /// @param context : BuildContext
  /// @return Widget : 生成されたUIオブジェクトツリー
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 背景色
      // 残り時間が20%(1分)未満の場合は黄色に、それ以外はテーマの背景色に設定
      backgroundColor: animationController.value < 0.2
          ? Colors.yellowAccent
          : Theme.of(context).scaffoldBackgroundColor,
      // アプリケーションヘッダ
      appBar: AppHeader(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Align(
                alignment: FractionalOffset.center,
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: AnimatedBuilder(
                          animation: animationController,
                          builder: (context, child) {
                            return CustomPaint(
                              painter: TimerPainter(
                                  animation: animationController,
                                  // タイマの背景色(残り時間)
                                  backgroundColor:
                                      animationController.value < 0.2
                                          ? Colors.redAccent
                                          : Theme.of(context).accentColor,
                                  color: animationController.value < 0.2
                                      ? Colors.yellowAccent
                                      : Theme.of(context)
                                          .scaffoldBackgroundColor),
                            );
                          },
                        ),
                      ),
                      Align(
                        alignment: FractionalOffset.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            AnimatedBuilder(
                              animation: animationController,
                              builder: (_, child) {
                                return Text(
                                  timerString,
                                  style: TextStyle(
                                    fontFamily: 'DSEG14Classic-Regular',
                                    fontSize: 60,
                                    color: animationController.value < 0.2
                                        ? Colors.red
                                        : Theme.of(context)
                                            .primaryTextTheme
                                            .bodyText1
                                            .color,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FloatingActionButton(
                    child: AnimatedBuilder(
                        animation: animationController,
                        builder: (_, child) {
                          return Icon(animationController.isAnimating
                              ? Icons.pause
                              : Icons.play_arrow);
                        }),
                    onPressed: () {
                      if (animationController.isAnimating) {
                        animationController.stop();
                      } else {
                        animationController.reverse(
                            from: animationController.value == 0.0
                                ? 1.0
                                : animationController.value);
                      }
                    },
                    backgroundColor: Colors.green,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
