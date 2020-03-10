import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';

///
/// サウンドクラス
class SoundEvent {
  ///
  /// コンストラクタ
  /// @param soundMap アセットに登録されているサウンドデータ
  SoundEvent(Map<String, String> soundMap) {
    _soundPool = Soundpool();
    _soundId = _loadSound(soundMap);
  }

  /// サウンドプールオブジェクト
  Soundpool _soundPool;

  /// サウンドプールに読み込まれたサウンドIDオブジェクト
  Future<Map<String, int>> _soundId;

  /// 再生中のサウンドIDオブジェクト
  int _alarmSoundStreamId;

  ///
  /// アセットに登録されているサウンドデータを非同期で設定する
  /// @param soundMap アセットに登録されているサウンドデータ
  /// @return Future<Map<String, int>> アセットに登録されているサウンドデータのキー文字列とサウンドIDのマップオブジェクト
  Future<Map<String, int>> _loadSound(Map<String, String> soundMap) async {
    var soundIdMap = <String, int>{};
    // 非同期でアセットからサウンドデータを読み出し、サウンドIDを取得する
    soundMap.forEach((key, value) async {
      await rootBundle
          .load(value)
          .then((asset) => _soundPool.load(asset))
          .then((id) => soundIdMap.putIfAbsent(key, () => id));
    });
    return soundIdMap;
  }

  ///
  /// サウンドを再生する
  /// @param types 再生するサウンドデータのキー文字列
  Future<void> playSound(String types) async {
    if (_soundId != null) {
      var alarmSound =
          await _soundId.then((value) => (value == null ? null : value[types]));
      if (alarmSound != null) {
        _alarmSoundStreamId = await _soundPool.play(alarmSound);
      }
    }
  }

  ///
  /// サウンドを停止する
  Future<void> stopSound() async {
    if (_alarmSoundStreamId != null) {
      await _soundPool.stop(_alarmSoundStreamId);
      _alarmSoundStreamId = null;
    }
  }

  ///
  /// サウンドリソースを解放する
  void dispose() {
    _soundPool.dispose();
  }
}
