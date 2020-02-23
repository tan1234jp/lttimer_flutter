import 'package:flutter/material.dart';
import 'package:lttimer/ui/header.dart';
import 'package:lttimer/ui/periodic_timer.dart';
import 'package:provider/provider.dart';

import 'ui/periodic_timer.dart';

typedef ButtonEventFunc = void Function();

void main() {
  runApp(LTTimerApp());
}

class LTTimerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: ChangeNotifierProvider(
        create: (context) => PeriodicTimer(300),
        child: _LTTimerApp(),
      ),
    );
  }
}

class _LTTimerApp extends StatelessWidget {
  ///
  /// ボタンイベント定義
  List _buttonEventHandler(PeriodicTimer timer) {
    ButtonEventFunc _func1;
    ButtonEventFunc _func2;

    switch (timer.runningState) {
      case TimerState.Ready:
        _func1 = timer.start;
        return [_func1, Icons.play_arrow, 'START', _func2];
      case TimerState.Running:
        _func1 = timer.stop;
        return [_func1, Icons.stop, 'STOP', _func2];
      case TimerState.Stop:
        _func1 = timer.start;
        _func2 = timer.reset;
        return [_func1, Icons.play_arrow, 'START', _func2];
      default:
        _func2 = timer.reset;
        return [_func1, Icons.play_arrow, 'START', _func2];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PeriodicTimer>(
      builder: (context, timer, _) {
        return Scaffold(
          backgroundColor: timer.time < 60
              ? Colors.yellowAccent
              : Theme.of(context).scaffoldBackgroundColor,
          appBar: AppHeader(),
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  timer.toString(),
                  style: TextStyle(
                    fontFamily: 'DSEG7Classic-Regular',
                    fontSize: 60,
                    color: timer.time < 60
                        ? Colors.red
                        : Theme.of(context).primaryTextTheme.bodyText1.color,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // 開始・停止
                    RaisedButton.icon(
                      onPressed: _buttonEventHandler(timer)[0] == null
                          ? null
                          : () => _buttonEventHandler(timer)[0](),
//                      onPressed: () => timer.runningState == TimerState.Ready
//                          ? timer.start()
//                          : timer.runningState == TimerState.Running
//                              ? timer.stop()
//                              : timer.runningState == TimerState.Stop
//                                  ? timer.start()
//                                  : null,
                      icon: Icon(
                        _buttonEventHandler(timer)[1],
//                        timer.runningState == TimerState.Ready
//                            ? Icons.play_arrow
//                            : timer.runningState == TimerState.Running
//                                ? Icons.stop
//                                : timer.runningState == TimerState.Stop
//                                    ? Icons.play_arrow
//                                    : Icons.play_arrow,
                        color: Colors.white,
                      ),
                      label: Text(_buttonEventHandler(timer)[2]),
//                      label: Text(timer.runningState == TimerState.Ready
//                          ? 'START'
//                          : timer.runningState == TimerState.Running
//                              ? 'STOP'
//                              : timer.runningState == TimerState.End
//                                  ? 'START'
//                                  : 'START'),
                      color: Colors.green,
                      textColor: Colors.white,
                    ),
                    SizedBox(
                      width: 128,
                    ),
                    // リセット
                    RaisedButton.icon(
                      onPressed: _buttonEventHandler(timer)[3] == null
                          ? null
                          : () => _buttonEventHandler(timer)[3](),
//                      onPressed: timer.runningState == TimerState.Ready
//                          ? null
//                          : timer.runningState == TimerState.Running
//                              ? null
//                              : timer.runningState == TimerState.Stop
//                                  ? () => timer.reset()
//                                  : () => timer.reset(),
                      icon: Icon(
                        Icons.refresh,
                        color: Colors.white,
                      ),
                      label: Text('RELOAD'),
                      color: Colors.green,
                      textColor: Colors.white,
                    ),
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
