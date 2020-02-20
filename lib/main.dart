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
                    RaisedButton(
                      child: Text("START"),
                      onPressed: timer.isRunning ? null : () => timer.start(),
                    ),
                    SizedBox(
                      width: 32,
                    ),
                    RaisedButton(
                      child: Text("STOP"),
                      onPressed: timer.isRunning ? () => timer.stop() : null,
                    ),
                    SizedBox(
                      width: 32,
                    ),
                    RaisedButton(
                      child: Text("RELOAD"),
                      onPressed: timer.isRunning ? null : () => timer.reset(),
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
