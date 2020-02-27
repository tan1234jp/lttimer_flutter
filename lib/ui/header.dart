import 'package:flutter/material.dart';
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
        );
      },
    );
  }

  ///
  /// AppBarの高さ調整を行う
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
