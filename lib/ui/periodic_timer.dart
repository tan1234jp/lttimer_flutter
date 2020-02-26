import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

///
/// タイマ状態を表す列挙型
enum TimerState {
  Ready, // 実行待ち
  Running, // 実行中
  End, // 終了
}

///
/// 定時タイマクラス
class PeriodicTimer with ChangeNotifier {
  ///
  /// コンストラクタ
  /// @param _initTimer 初期タイマ時間(msec)
  PeriodicTimer(int initTimer) {
    this._initTimer = initTimer;
    this._timer = initTimer;
    this._audioPlayer.open('assets/audios/dora.mp3');
  }

  /// 初期タイマ時間
  int _initTimer = 0;

  // タイマ開始日時
  int _currentDateTime;

  /// 残り時間
  int _timer = 0;

  /// タイマ稼働フラグ(true=稼働中 : false=停止中)
  TimerState _stateRunning = TimerState.Ready;

  /// 残り時間の取得
  int get time => _timer;

  void set time(int _timer) {
    this._initTimer = _timer * 60000;
    this._timer = _timer * 60000;
  }

  /// タイマ稼働フラグの取得
  TimerState get runningState => _stateRunning;

  // 残り時間がなくなった時に鳴らす効果音
  final _audioPlayer = AssetsAudioPlayer();

  ///
  /// タイマを開始する
  void start() {
    // タイマ開始
    if (_stateRunning == TimerState.Ready) {
      _stateRunning = TimerState.Running;
      _currentDateTime = DateTime.now().millisecondsSinceEpoch;

      // 100ミリ秒毎に残り時間を減らす
      Timer.periodic(Duration(milliseconds: 100), (timer) {
        // 残り時間がなくなった場合はタイマを停止する
        if (_timer <= 0) {
          _stateRunning = TimerState.End;
          // ドラを鳴らす（終了）
          _audioPlayer.play();
          timer.cancel();
          notifyListeners();
        }
        int _now = DateTime.now().millisecondsSinceEpoch;
        _timer -= (_now - _currentDateTime);
        _currentDateTime = _now;
        notifyListeners();
      });
    }
  }

  ///
  /// タイマをリセットする
  void reset() {
    _timer = _initTimer;
    _stateRunning = TimerState.Ready;
    notifyListeners();
  }

  ///
  /// 残り時間を「99:99.9」形式の文字列で返す
  @override
  String toString() {
    if (_timer == null) {
      return '';
    }

    if (_timer <= 0) {
      return 'TIME UP!';
    }
    int minutes = _timer ~/ 60000;
    int seconds = (_timer - minutes * 60000) ~/ 1000;
    int dseconds = (_timer % 1000) ~/ 100;
    return minutes.toString().padLeft(2, "0") +
        ":" +
        seconds.toString().padLeft(2, "0") +
        "." +
        dseconds.toString();
  }
}
