import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

///
/// タイマ状態を表す列挙型
enum TimerState {
  Ready, // 実行待ち
  Running, // 実行中
  Stop, // 停止中
  End, // 終了
}

///
/// 定時タイマクラス
class PeriodicTimer with ChangeNotifier {
  ///
  /// コンストラクタ
  /// @param _initTimer 初期タイマ時間(sec)
  PeriodicTimer(double initTimer) {
    this._initTimer = initTimer;
    this._timer = initTimer;
    this._audioPlayer.open('assets/audios/dora.mp3');
  }

  /// 初期タイマ時間
  double _initTimer = 0;

  /// 残り時間
  double _timer = 0;

  /// タイマ稼働フラグ(true=稼働中 : false=停止中)
  TimerState _stateRunning = TimerState.Ready;

  /// 残り時間の取得
  double get time => _timer;

  /// タイマ稼働フラグの取得
  TimerState get runningState => _stateRunning;

  final _audioPlayer = AssetsAudioPlayer();

  ///
  /// タイマを開始する
  void start() {
    // タイマが停止中、かつ、残り時間が0秒より多い場合にタイマ開始
    if ((_stateRunning == TimerState.Ready ||
            _stateRunning == TimerState.Stop) &&
        _timer > 0) {
      _stateRunning = TimerState.Running;

      // 100ミリ秒毎に残り時間を減らす
      Timer.periodic(Duration(milliseconds: 100), (timer) {
        // 残り時間がなくなった、または、タイマが実行中ではない場合はタイマを停止する
        if (_timer <= 0 || _stateRunning != TimerState.Running) {
          if (_timer <= 0) {
            // 残り時間が0の場合はドラを鳴らす（終了）
            _stateRunning = TimerState.End;
            _audioPlayer.play();
            notifyListeners();
          }
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
    _stateRunning = TimerState.Stop;
  }

  ///
  /// タイマをリセットする
  void reset() {
    _timer = _initTimer;
    _stateRunning = TimerState.Ready;
    notifyListeners();
  }

  ///
  /// 残り時間を「99:99」形式の文字列で返す
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
