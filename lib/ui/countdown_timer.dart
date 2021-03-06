import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lttimer/ui/header.dart';
import 'package:lttimer/ui/timer_painter.dart';
import 'package:soundpool/soundpool.dart';
import 'package:vibration/vibration.dart';

///
/// カウントダウンタイマクラス
class CountDownTimer extends StatefulWidget {
  ///
  /// コンストラクタ
  /// @param duration タイマ初期時間
  CountDownTimer(this.duration);

  /// タイマ初期時間
  final Duration duration;

  ///
  /// StatefulWidgetオブジェクトを生成する
  @override
//  _CountDownTimer createState() => _CountDownTimer(duration);
  _CountDownTimer createState() => _CountDownTimer();
}

///
/// カウントダウンタイマ 内部クラス
class _CountDownTimer extends State<CountDownTimer>
    with SingleTickerProviderStateMixin {
  ///
  /// コンストラクタ
  /// @param duration タイマ初期時間
//  _CountDownTimer(this.duration);

  /// タイマ初期時間
//  final Duration duration;

  /// アニメーションコントロール
  AnimationController _animationController;

  /// サウンドプールオブジェクト
  Soundpool _soundPool;

  /// サウンドプールに読み込まれたサウンドIDオブジェクト
  Future<Map<String, int>> _soundId;

  /// 再生中のサウンドIDオブジェクト
  int _alarmSoundStreamId;

  ///
  /// 残り時間を「99:99.9」形式の文字列で返す
  String get timerString {
    if (_animationController.value <= 0.0) {
      return 'TIME UP';
    } else {
      Duration duration =
          _animationController.duration * _animationController.value;
      return '${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}.${((duration.inMilliseconds % 1000) ~/ 100).toString()}';
    }
  }

  ///
  /// アニメーションの初期設定を行う
  @override
  void initState() {
    super.initState();
    // アニメーションのインスタンスを生成する
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
      value: 1.0,
    )..addListener(() {
        if (_animationController.value <= 0.0) {
          // アニメーション終了通知
          _playSound('dora');
          Vibration.vibrate(
            pattern: [0, 1000, 500, 1000, 500, 1000],
          );
        }
        setState(() {});
      });

    // 初期値を1.0(100%)に設定
    setState(() {
      _animationController.value = 1.0;
    });
    // サウンドプールの初期化
    _soundPool = Soundpool();
    // アセットからデータ読み込み
    _soundId = _loadSound(<String, String>{
      'silent': 'assets/audios/silent.mp3',
      'dora': 'assets/audios/dora.mp3',
    });
  }

  ///
  /// タイマ時間を設定する
  /// @param duration タイマ時間
  void setDuration(Duration duration) {
    _animationController.stop();
    setState(() {
      _animationController.value = 1.0;
      _animationController.duration = duration;
    });
  }

  ///
  /// オブジェクト破棄処理
  @override
  void dispose() {
    _animationController.dispose();
    _soundPool.dispose();
    super.dispose();
  }

  ///
  /// UIを生成する
  /// @param context : BuildContext
  /// @return Widget : 生成されたUIオブジェクトツリー
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 背景色
      // 残り時間が20%未満の場合は黄色に、それ以外はテーマの背景色に設定
      backgroundColor: _animationController.value < 0.2
          ? Colors.yellowAccent
          : Theme.of(context).scaffoldBackgroundColor,
      // アプリケーションヘッダ
      appBar: AppHeader(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 7,
              child: Align(
                alignment: FractionalOffset.center,
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return CustomPaint(
                              painter: TimerPainter(
                                animation: _animationController,
                                // タイマの背景色(残り時間)
                                backgroundColor:
                                    _animationController.value < 0.2
                                        ? Colors.redAccent
                                        : Theme.of(context).accentColor,
                                color: _animationController.value < 0.2
                                    ? Colors.yellowAccent
                                    : Theme.of(context).scaffoldBackgroundColor,
                              ),
                            );
                          },
                        ),
                      ),
                      Align(
                        alignment: FractionalOffset.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            AnimatedBuilder(
                              animation: _animationController,
                              builder: (_, child) {
                                return Text(
                                  timerString,
                                  style: TextStyle(
                                    fontFamily: 'DSEG14Classic-Regular',
                                    fontSize: 48,
                                    color: _animationController.value < 0.2
                                        ? Colors.red
                                        : Theme.of(context)
                                            .primaryTextTheme
                                            .bodyText1
                                            .color,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton.icon(
                      onPressed: _animationController.isAnimating
                          ? null
                          : () {
                              _playSound('silent');
                              _animationController.reverse(
                                  from: _animationController.value == 0.0
                                      ? 1.0
                                      : _animationController.value);
                            },
                      icon: Icon(Icons.play_arrow),
                      label: const Text(
                        'PLAY',
                        style: TextStyle(
                          fontFamily: 'DSEG14Classic-Regular',
                        ),
                      ),
                      color: Colors.green,
                      textColor: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///
  /// サウンドデータをロードする
  /// @param soundMap : <Key,assetファイル名>のMapオブジェクト
  /// @return Future<Map<String, int>> : <Key, 読みこんだサウンドデータのID>のMapオブジェクト
  Future<Map<String, int>> _loadSound(Map<String, String> soundMap) async {
    var soundIdMap = <String, int>{};
    soundMap.forEach((key, value) async {
      await rootBundle
          .load(value) // アセットにあるサウンドデータを読み込む
          .then((asset) => _soundPool.load(asset)) // 読み込んだデータをサウンドプールに格納する
          .then((id) => soundIdMap.putIfAbsent(
              key, () => id)); // サウンドプールから割り当てられたIDをMapに登録する
    });
    return soundIdMap;
  }

  ///
  /// サウンドを再生する
  /// @param key : 再生するサウンドのキー文字列
  Future<void> _playSound(String types) async {
    if (_soundId != null) {
      var _alarmSound = await _soundId.then(
          (value) => (value == null ? null : value[types])); // キーからIDを取得する
      // 取得したIDでサウンドを再生する
      // 再生中のサウンドは停止する
      if (_alarmSound != null) {
        await _stopSound();
        _alarmSoundStreamId = await _soundPool.play(_alarmSound);
      }
    }
  }

  ///
  /// サウンドを停止する
  Future<void> _stopSound() async {
    // 再生中の場合は停止する
    if (_alarmSoundStreamId != null) {
      await _soundPool.stop(_alarmSoundStreamId);
      _alarmSoundStreamId = null;
    }
  }
}
