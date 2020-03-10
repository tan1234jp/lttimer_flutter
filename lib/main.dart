import 'package:flutter/material.dart';
import 'package:lttimer/ui/header.dart';
import 'package:lttimer/ui/periodic_timer.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

typedef ButtonEventFunc = void Function();

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
/*
      home: CountDownTimer(const Duration(minutes: 5, seconds: 0)),
 */
      home: ChangeNotifierProvider(
        create: (context) => PeriodicTimer(5 * 60 * 1000),
        child: _LTTimerApp(),
      ),
    );
  }
}

class _LTTimerApp extends StatelessWidget {
  Tuple3<ButtonEventFunc, IconData, String> _buttonEventHandler(
      PeriodicTimer timer) {
    ButtonEventFunc _func1;

    switch (timer.state) {
      case TimerState.ready:
        _func1 = timer.start;
        return Tuple3(_func1, Icons.play_arrow, 'START');
      case TimerState.running:
        // fall through
        return Tuple3(_func1, Icons.stop, '');
      case TimerState.end:
        _func1 = timer.reset;
        return Tuple3(_func1, Icons.refresh, 'RESET');
      default:
        return Tuple3(_func1, Icons.stop, '');
    }
  }

  Widget _createButton(PeriodicTimer timer) {
    if (timer.state == TimerState.running) {
      return Container();
    }

    return RaisedButton.icon(
      onPressed: _buttonEventHandler(timer).item1 == null
          ? null
          : () => _buttonEventHandler(timer).item1(),
      icon: Icon(
        _buttonEventHandler(timer).item2,
      ),
      label: Text(_buttonEventHandler(timer).item3),
      color: Colors.green,
      textColor: Colors.white,
    );
  }

  double _calcWidgetSize(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return size.width < size.height ? size.height : size.width;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PeriodicTimer>(
      builder: (context, timer, _) {
        return Scaffold(
          backgroundColor: timer.time < 60000
              ? Colors.yellowAccent
              : Theme.of(context).scaffoldBackgroundColor,
          appBar: AppHeader(),
          body: SafeArea(
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 7,
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: CircularPercentIndicator(
                      radius: _calcWidgetSize(context) / 2,
                      lineWidth: 6.0,
                      percent: timer.time / (5 * 60 * 1000),
                      backgroundColor: Colors.transparent,
                      progressColor: timer.time < 60000
                          ? Colors.redAccent
                          : Theme.of(context).accentColor,
                      center: Text(
                        timer.toString(),
                        style: TextStyle(
                          fontFamily: 'DSEG14Classic-Regular',
                          fontSize: 48,
                          color: timer.time < 60000
                              ? Colors.red
                              : Theme.of(context)
                                  .primaryTextTheme
                                  .bodyText1
                                  .color,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _createButton(timer),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
