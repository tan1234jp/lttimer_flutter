import 'dart:math';

import 'package:flutter/material.dart';

///
/// タイマ描画クラス
class TimerPainter extends CustomPainter {
  /// コンストラクタ
  /// @param animation : アニメーションコントローラオブジェクト
  /// @param backgroundColor : 背景色
  /// @param color : 描画色
  TimerPainter({this.animation, this.backgroundColor, this.color});

  /// アニメーションコントローラ
  final Animation<double> animation;

  /// 背景色
  final Color backgroundColor;

  /// 描画色
  final Color color;

  ///
  /// 描画
  /// @param canvas : Canvasオブジェクト
  /// @param size : オブジェクトのサイズ
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // 背景色で円を描画する（塗りつぶす）
    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    // 残り時間を描画色で弧を描画する
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * pi;
    canvas.drawArc(Offset.zero & size, pi * 1.5, -progress, false, paint);
  }

  ///
  /// 再描画判定
  /// @param old : 前回の描画オブジェクト
  /// @return 再描画が必要な場合はtrue
  @override
  bool shouldRepaint(TimerPainter old) {
    /// 以下のオブジェクトに変化があった場合にtrue
    /// ・アニメーションコントローラオブジェクト
    /// ・描画色
    /// ・背景色
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}
