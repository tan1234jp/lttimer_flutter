import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

///
/// タイマ状態を表す列挙型
enum TimerState {
  ready, // 実行待ち
  running, // 実行中
  end, // 終了
}

///
/// 定時タイマクラス
class PeriodicTimer with ChangeNotifier {
  ///
  /// コンストラクタ
  /// @param _initTimer 初期タイマ時間(ミリ秒)
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
  TimerState _stateRunning = TimerState.ready;

  /// 残り時間の取得
  int get time => _timer;

  void newTime(int _timer) {
    this._initTimer = _timer * 60000;
    this._timer = _timer * 60000;
    notifyListeners();
  }

  /// タイマ稼働フラグの取得
  TimerState get runningState => _stateRunning;

  // 残り時間がなくなった時に鳴らす効果音
  final _audioPlayer = AssetsAudioPlayer();

  ///
  /// タイマを開始する
  void start() {
    // タイマ開始
    if (_stateRunning == TimerState.ready) {
      _stateRunning = TimerState.running;
      _currentDateTime = DateTime.now().millisecondsSinceEpoch;

      // 100ミリ秒毎に残り時間を減らす
      Timer.periodic(Duration(milliseconds: 100), (timer) {
        // 残り時間がなくなった場合はタイマを停止する
        if (_timer <= 0) {
          _stateRunning = TimerState.end;
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
    _stateRunning = TimerState.ready;
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
    int deciSeconds = (_timer % 1000) ~/ 100;
    return minutes.toString().padLeft(2, "0") +
        ":" +
        seconds.toString().padLeft(2, "0") +
        "." +
        deciSeconds.toString();
  }
}
