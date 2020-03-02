import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lttimer/ui/header.dart';
import 'package:lttimer/ui/timer_painter.dart';
import 'package:soundpool/soundpool.dart';

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
  _CountDownTimer createState() => _CountDownTimer(duration);
}

///
/// カウントダウンタイマ 内部クラス
class _CountDownTimer extends State<CountDownTimer>
    with TickerProviderStateMixin {
  ///
  /// コンストラクタ
  /// @param duration タイマ初期時間
  _CountDownTimer(this.duration);

  /// タイマ初期時間
  final Duration duration;

  /// アニメーションコントロール
  AnimationController animationController;

  /// サウンドプールオブジェクト
  Soundpool _soundPool;

  /// サウンドプールに読み込まれたサウンドIDオブジェクト
  Future<Map<String, int>> _soundId;

  /// 再生中のサウンドIDオブジェクト
  int _alarmSoundStreamId;

  /// サウンドマップ定義
  var _soundsMap = <String, String>{
    'silent': 'assets/audios/silent.mp3',
    'dora': 'assets/audios/dora.mp3',
  };

  ///
  /// 残り時間を「99:99.9」形式の文字列で返す
  String get timerString {
    Duration duration =
        animationController.duration * animationController.value;
    return '${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}.${((duration.inMilliseconds % 1000) ~/ 100).toString()}';
  }

  ///
  /// アニメーションの初期設定を行う
  @override
  void initState() {
    super.initState();
    // アニメーションのインスタンスを生成する（5分で終了）
    animationController = AnimationController(vsync: this, duration: duration)
      ..addStatusListener((status) {
        // アニメーションの状態変更通知
        if (status == AnimationStatus.completed) {
          if (_alarmSoundStreamId != null) {
            _stopSound();
          }
          // アニメーション終了通知
          if (animationController.value == 0.0) {
            _playSound('dora');
          }
        }
      });
    // 初期値を1.0(100%)に設定
    animationController.value = 1.0;
    _soundPool = Soundpool();
    _soundId = _loadSound(_soundsMap);
  }

  ///
  /// オブジェクト破棄処理
  @override
  void dispose() {
    animationController.dispose();
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
      // 残り時間が20%(1分)未満の場合は黄色に、それ以外はテーマの背景色に設定
      backgroundColor: animationController.value < 0.2
          ? Colors.yellowAccent
          : Theme.of(context).scaffoldBackgroundColor,
      // アプリケーションヘッダ
      appBar: AppHeader(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Align(
                alignment: FractionalOffset.center,
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: AnimatedBuilder(
                          animation: animationController,
                          builder: (context, child) {
                            return CustomPaint(
                              painter: TimerPainter(
                                  animation: animationController,
                                  // タイマの背景色(残り時間)
                                  backgroundColor:
                                      animationController.value < 0.2
                                          ? Colors.redAccent
                                          : Theme.of(context).accentColor,
                                  color: animationController.value < 0.2
                                      ? Colors.yellowAccent
                                      : Theme.of(context)
                                          .scaffoldBackgroundColor),
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
                              animation: animationController,
                              builder: (_, child) {
                                return Text(
                                  timerString,
                                  style: TextStyle(
                                    fontFamily: 'DSEG14Classic-Regular',
                                    fontSize: 60,
                                    color: animationController.value < 0.2
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
            Container(
              margin: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FloatingActionButton(
                    child: AnimatedBuilder(
                        animation: animationController,
                        builder: (_, child) {
                          return Icon(animationController.isAnimating
                              ? Icons.pause
                              : Icons.play_arrow);
                        }),
                    onPressed: () {
                      _playSound('silent'); // iOS(iPadOS)でサウンド再生されない対策
                      if (animationController.isAnimating) {
                        animationController.stop();
                      } else {
                        animationController.reverse(
                            from: animationController.value == 0.0
                                ? 1.0
                                : animationController.value);
                      }
                    },
                    backgroundColor: Colors.green,
                  ),
                ],
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
  /// @return Future<Map<String int>> : <Key,読みこんだサウンドデータのID>のMapオブジェクト
  Future<Map<String, int>> _loadSound(Map<String, String> soundMap) async {
    var soundIdMap = <String, int>{};
    soundMap.forEach((key, value) async {
      // assetからサウンドデータを読み込む
      var asset = await rootBundle.load(value);
      int id = await _soundPool.load(asset);
      soundIdMap.putIfAbsent(key, () => id);
    });

    return soundIdMap;
  }

  ///
  /// サウンドを再生する
  /// @param key : 再生するサウンドのキー文字列
  Future<void> _playSound(String types) async {
    if (_soundId != null) {
      var _alarmSound =
          await _soundId.then((value) => (value == null ? null : value[types]));
      if (_alarmSound != null) {
        _alarmSoundStreamId = await _soundPool.play(_alarmSound);
      }
    }
  }

  ///
  /// サウンドを停止する
  Future<void> _stopSound() async {
    if (_alarmSoundStreamId != null) {
      await _soundPool.stop(_alarmSoundStreamId);
      _alarmSoundStreamId = null;
    }
  }
}
