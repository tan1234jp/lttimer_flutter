import 'package:flutter/material.dart';
import 'package:lttimer/ui/header.dart';
import 'package:lttimer/ui/periodic_timer.dart';
import 'package:provider/provider.dart';

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
                    RaisedButton.icon(
                      onPressed: () =>
                          timer.isRunning ? timer.stop() : timer.start(),
                      icon: Icon(
                        timer.isRunning ? Icons.stop : Icons.play_arrow,
                        color: Colors.white,
                      ),
                      label: Text(timer.isRunning ? 'STOP' : 'START'),
                      color: Colors.green,
                      textColor: Colors.white,
                    ),
                    SizedBox(
                      width: 128,
                    ),
                    RaisedButton.icon(
                      onPressed: timer.isRunning ? null : () => timer.reset(),
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
