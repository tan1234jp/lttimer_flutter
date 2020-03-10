import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lttimer/ui/sound_event.dart';
import 'package:vibration/vibration.dart';

///
/// 現在のタイマ状態を表す列挙型
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
  /// @param initTimer 初期タイマ時間(ミリ秒)
  PeriodicTimer(int initTimer) {
    this._initTimer = initTimer;
    this._timer = initTimer;
  }

  /// 初期タイマ時間
  int _initTimer = 0;

  /// 残り時間
  int _timer = 0;

  /// タイマ開始日時
  int _currentDateTime;

  /// タイマ状態
  TimerState _state = TimerState.ready;

  /// 再生するサウンドの設定
  final SoundEvent _soundEvent = SoundEvent(<String, String>{
    'silent': 'assets/audios/silent.mp3',
    'dora': 'assets/audios/dora.mp3',
  });

  /// 残り時間の取得
  int get time => _timer;

  /// タイマ状態の取得
  TimerState get state => _state;

  /// タイマ時間の設定
  /// @param timer タイマ時間(ミリ秒)
  set time(int timer) {
    this._initTimer = timer;
    this._timer = timer;
    notifyListeners();
  }

  ///
  /// タイマを開始する
  void start() {
    // 実行待ちの時にタイマを稼働させる
    if (_state == TimerState.ready) {
      // 実行待ち → 実行中
      _state = TimerState.running;
      // 開始日時を設定
      _currentDateTime = DateTime.now().millisecondsSinceEpoch;
      // 開始音を鳴らす(ダミー)
      _soundEvent.playSound('silent');

      // 100ミリ秒毎にイベントを発生させる
      Timer.periodic(const Duration(milliseconds: 100), (timer) {
        // 残り時間がなくなったらイベントを停止させる
        if (_timer <= 0) {
          timer.cancel();
          _state = TimerState.end;
          // 終了音を鳴らす
          _soundEvent.playSound('dora');
          Vibration.vibrate(
            pattern: [0, 1000, 500, 1000, 500, 1000],
          );
          notifyListeners();
        }
        // 残り時間の計算
        int now = DateTime.now().millisecondsSinceEpoch;
        _timer -= (now - _currentDateTime);
        _currentDateTime = now;
        notifyListeners();
      });
    }
  }

  ///
  /// タイマをリセットする
  void reset() {
    _timer = _initTimer;
    _state = TimerState.ready;
    notifyListeners();
  }

  ///
  /// 残り時間を「99:99.9」形式に変換する
  @override
  String toString() {
    if (_timer == null) {
      return '';
    }

    if (_timer <= 0) {
      return 'TIME UP';
    }

    int minutes = _timer ~/ 60000;
    int seconds = (_timer - minutes * 60000) ~/ 1000;
    int deciSeconds = (_timer % 1000) ~/ 100;

    return minutes.toString().padLeft(2, '0') +
        ':' +
        seconds.toString().padLeft(2, '0') +
        '.' +
        deciSeconds.toString();
  }

  ///
  /// リソースを解放する
  @override
  void dispose() {
    _soundEvent.dispose();
    super.dispose();
  }
}
