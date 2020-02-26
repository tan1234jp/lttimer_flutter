import 'package:flutter/material.dart';
import 'package:lttimer/preferences/preferences.dart';
import 'package:lttimer/ui/periodic_timer.dart';
import 'package:provider/provider.dart';

///
/// ヘッダ領域のUI設定クラス
class AppHeader extends StatelessWidget with PreferredSizeWidget {
  ///
  /// UIを生成する
  /// @param context: BuildContext
  /// @return 生成されたUIウィジェットオブジェクト
  @override
  Widget build(BuildContext context) {
    return Consumer<PeriodicTimer>(
      builder: (context, timer, _) {
        return AppBar(
          title: Text('LT Timer'),
          centerTitle: true,
          elevation: 0,
          actions: <Widget>[
            IconButton(
                padding: const EdgeInsets.all(8.0),
                icon: Icon(Icons.settings),
                onPressed: () {
                  if (timer.runningState == TimerState.Ready) {
                    Navigator.push(
                        context,
                        MaterialPageRoute<Null>(
                          settings: const RouteSettings(name: "/preferences"),
                          builder: (BuildContext context) => Preferences(),
                        ));
                  } else {
                    return null;
                  }
                }),
          ],
        );
      },
    );
  }

  ///
  /// AppBarの高さ調整を行う
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
