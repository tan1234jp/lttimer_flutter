import 'dart:async';

import 'package:flutter/material.dart';

///
/// 定時タイマクラス
class PeriodicTimer with ChangeNotifier {
  ///
  /// コンストラクタ
  /// @param _initTimer 初期タイマ時間(sec)
  PeriodicTimer(double initTimer) {
    this._initTimer = initTimer;
    this._timer = initTimer;
  }

  /// 初期タイマ時間
  double _initTimer = 0;

  /// 残り時間
  double _timer = 0;

  /// タイマ稼働フラグ(true=稼働中 : false=停止中)
  var _isRunning = false;

  /// 残り時間の取得
  double get time => _timer;

  /// タイマ稼働フラグの取得
  bool get isRunning => _isRunning;

  ///
  /// タイマを開始する
  void start() {
    // タイマが停止中、かつ、残り時間が0秒より多い場合にタイマ開始
    if (!_isRunning && _timer > 0) {
      _isRunning = true;

      // 100ミリ秒毎に残り時間を減らす
      Timer.periodic(Duration(milliseconds: 100), (timer) {
        // 残り時間がなくなった、または、タイマ稼働中フラグがfalseの場合はタイマを停止する
        if (_timer <= 0 || !_isRunning) {
          timer.cancel();
        }
        _timer -= 0.1;
        notifyListeners();
      });
    }
  }

  ///
  /// タイマを停止する
  void stop() {
    _isRunning = false;
  }

  /// タイマをリセットする(稼働中のタイマも停止する)
  void reset() {
    _isRunning = false;
    notifyListeners();
    _timer = _initTimer;
    notifyListeners();
  }

  @override
  String toString() {
    if (_timer == null) {
      return '';
    }

    int minutes = _timer ~/ 60;
    int seconds = (_timer - minutes * 60) ~/ 1;
    return (minutes.toString().padLeft(2, "0") +
        ":" +
        seconds.toString().padLeft(2, "0"));
  }
}
