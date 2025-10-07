import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';

// DLL を開く
final DynamicLibrary _open = () {
  if (!Platform.isWindows) {
    throw UnsupportedError('Windows only');
  }
  return DynamicLibrary.open('RealPassSDK.dll');
}();

final _sdk = _open;

// ===== typedef（Native と Dart を分ける） =====
typedef RP_InitSDK_Native = Int32 Function(Int32, Pointer<Int32>);
typedef RP_InitSDK_Dart = int Function(int, Pointer<Int32>);

typedef RP_ReleaseSDK_Native = Int32 Function();
typedef RP_ReleaseSDK_Dart = int Function();

typedef RP_Connect_Native = Int32 Function(Int32, Pointer<Void>);
typedef RP_Connect_Dart = int Function(int, Pointer<Void>);

typedef RP_Disconnect_Native = Int32 Function();
typedef RP_Disconnect_Dart = int Function();

typedef RP_SetConfiguration_Native = Int32 Function(Int32, Int32);
typedef RP_SetConfiguration_Dart = int Function(int, int);

typedef RP_StartDocDetect_Native = Int32 Function(Int32);
typedef RP_StartDocDetect_Dart = int Function(int);

typedef RP_StopDocDetect_Native = Int32 Function();
typedef RP_StopDocDetect_Dart = int Function();

typedef RP_ReadDoc_Native = Int32 Function();
typedef RP_ReadDoc_Dart = int Function();

typedef RP_GetMRZTextEx_Native =
    Int32 Function(Pointer<Int8>, Pointer<Int8>, Pointer<Int8>);
typedef RP_GetMRZTextEx_Dart =
    int Function(Pointer<Int8>, Pointer<Int8>, Pointer<Int8>);

typedef RP_GetImage_Native =
    Int32 Function(Int32, Int32, Pointer<Uint8>, Pointer<Int32>, Int32);
typedef RP_GetImage_Dart =
    int Function(int, int, Pointer<Uint8>, Pointer<Int32>, int);

// ===== lookupFunction（名前を _rp... に統一） =====
final _rpInitSDK = _sdk.lookupFunction<RP_InitSDK_Native, RP_InitSDK_Dart>(
  'RP_InitSDK',
);
final _rpReleaseSDK = _sdk
    .lookupFunction<RP_ReleaseSDK_Native, RP_ReleaseSDK_Dart>('RP_ReleaseSDK');
final _rpConnect = _sdk.lookupFunction<RP_Connect_Native, RP_Connect_Dart>(
  'RP_Connect',
);
final _rpDisconnect = _sdk
    .lookupFunction<RP_Disconnect_Native, RP_Disconnect_Dart>('RP_Disconnect');
final _rpSetCfg = _sdk
    .lookupFunction<RP_SetConfiguration_Native, RP_SetConfiguration_Dart>(
      'RP_SetConfiguration',
    );
final _rpStartDocDetect = _sdk
    .lookupFunction<RP_StartDocDetect_Native, RP_StartDocDetect_Dart>(
      'RP_StartDocDetect',
    );
final _rpStopDocDetect = _sdk
    .lookupFunction<RP_StopDocDetect_Native, RP_StopDocDetect_Dart>(
      'RP_StopDocDetect',
    );
final _rpReadDoc = _sdk.lookupFunction<RP_ReadDoc_Native, RP_ReadDoc_Dart>(
  'RP_ReadDoc',
);
final _rpGetMRZTextEx = _sdk
    .lookupFunction<RP_GetMRZTextEx_Native, RP_GetMRZTextEx_Dart>(
      'RP_GetMRZTextEx',
    );
final _rpGetImage = _sdk.lookupFunction<RP_GetImage_Native, RP_GetImage_Dart>(
  'RP_GetImage',
);

// ---- SDKの定数 ----
const int RP_SUCCESS = 0x0000;
const int RP_ENABLE = 1;

const int RP_CONFIG_TYPE_OCR_ENABLE = 0x0301;
const int RP_CONFIG_TYPE_SCAN_ENABLE = 0x0401;
const int RP_CONFIG_TYPE_EDOC_ENABLE = 0x0501;
const int RP_CONFIG_TYPE_SCAN_LIGHT_IR = 0x0411;
const int RP_CONFIG_TYPE_SCAN_LIGHT_WH = 0x0412;
const int RP_CONFIG_TYPE_SCAN_LIGHT_UV = 0x0413;
const int RP_CONFIG_TYPE_SCAN_ENHANCED = 0x0421;

const int RP_CONFIG_TYPE_DOC_DETECT_CAMERA = 0x0211;

const int RP_IMG_TYPE_TD3_WH = 0x0013; // パスポート見開き（白色）
const int RP_IMG_FORMAT_BMP = 0; // SDK側定義
const int RP_COMP_RATIO = 75; // BMPなら無視

class RealPass {
  static final _resultsCtrl = StreamController<Map<String, String>>.broadcast();
  static Stream<Map<String, String>> get results => _resultsCtrl.stream;

  static Timer? _loop;
  static bool _busy = false;
  static bool _armed = false;

  static int _ensure(String label, int code) {
    if (code != RP_SUCCESS) {
      throw Exception('[$label] failed: 0x${code.toRadixString(16)}');
    }
    return code;
  }

  /// 初期化＋接続＋基本設定まで
  static void initAndConnect() {
    print('RealPass.initAndConnect');
    final devType = calloc<Int32>();
    try {
      _ensure('RP_InitSDK', _rpInitSDK(0, devType));
      _ensure('RP_Connect', _rpConnect(0, nullptr));
      _ensure('CFG_OCR', _rpSetCfg(RP_CONFIG_TYPE_OCR_ENABLE, RP_ENABLE));
      _ensure('CFG_SCAN', _rpSetCfg(RP_CONFIG_TYPE_SCAN_ENABLE, RP_ENABLE));
      _ensure('CFG_EDOC', _rpSetCfg(RP_CONFIG_TYPE_EDOC_ENABLE, RP_ENABLE));
      _rpSetCfg(RP_CONFIG_TYPE_SCAN_LIGHT_IR, RP_ENABLE);
      _rpSetCfg(RP_CONFIG_TYPE_SCAN_LIGHT_WH, RP_ENABLE);
      _rpSetCfg(RP_CONFIG_TYPE_SCAN_LIGHT_UV, RP_ENABLE);
      _rpSetCfg(RP_CONFIG_TYPE_SCAN_ENHANCED, RP_ENABLE);
    } finally {
      calloc.free(devType);
    }
  }

  static void startAlwaysOn({
    Duration cycle = const Duration(milliseconds: 900),
  }) {
    // すでに初期化済みでなければ初期化
    // （initAndConnect内で Directory.current を exe フォルダにしている想定）
    try {
      initAndConnect();
    } catch (_) {
      // 既に初期化済みなら無視
    }

    // 検出をオンにしておく
    _ensure(
      'RP_StartDocDetect',
      _rpStartDocDetect(RP_CONFIG_TYPE_DOC_DETECT_CAMERA),
    );
    _armed = true;

    _loop?.cancel();
    _loop = Timer.periodic(cycle, (_) async {
      if (!_armed || _busy) return;
      _busy = true;
      try {
        // ドキュメントが置かれていなくても ReadDoc は安全。
        // 置かれていれば数秒以内にMRZ/ICが取れる。
        final info = await _readOnce(timeout: const Duration(seconds: 4));
        if (info != null) {
          _resultsCtrl.add(info); // UIへ流す
        }
      } catch (_) {
        // 失敗は握りつぶして次サイクルへ
      } finally {
        _busy = false;
      }
    });
  }

  static void shutdown() {
    _rpStopDocDetect();
    _rpDisconnect();
    _rpReleaseSDK();
  }

  // 2) 停止（画面破棄時に呼ぶ）
  static void stopAlwaysOn() {
    _armed = false;
    _loop?.cancel();
    _loop = null;
    // デバイスは使い回すなら shutdown しなくてもOK。終了時は shutdown() を呼ぶ。
  }

  // 3) 1回だけ読み（StartDocDetectは外で済ませる前提）
  static Future<Map<String, String>?> _readOnce({
    required Duration timeout,
  }) async {
    _ensure('RP_ReadDoc', _rpReadDoc());

    final sw = Stopwatch()..start();
    while (sw.elapsed < timeout) {
      // 先にIC（チップ）を試す
      final c1 = calloc<Int8>(128),
          c2 = calloc<Int8>(128),
          c3 = calloc<Int8>(128);
      try {
        final rIC = _rp_eDoc_GetMRZEx(c1, c2, c3);
        if (rIC == RP_SUCCESS) {
          final mrz1 = c1.cast<Utf8>().toDartString();
          final mrz2 = c2.cast<Utf8>().toDartString();
          final res = _parseMrzNameNat(mrz1, mrz2);
          return {'source': 'chip', ...res};
        }
      } finally {
        calloc.free(c1);
        calloc.free(c2);
        calloc.free(c3);
      }

      // 光学MRZを試す
      final o1 = calloc<Int8>(128),
          o2 = calloc<Int8>(128),
          o3 = calloc<Int8>(128);
      try {
        final rMRZ = _rpGetMRZTextEx(o1, o2, o3);
        if (rMRZ == RP_SUCCESS) {
          final mrz1 = o1.cast<Utf8>().toDartString();
          final mrz2 = o2.cast<Utf8>().toDartString();
          final res = _parseMrzNameNat(mrz1, mrz2);
          return {'source': 'optical', ...res};
        }
      } finally {
        calloc.free(o1);
        calloc.free(o2);
        calloc.free(o3);
      }

      await Future.delayed(const Duration(milliseconds: 200));
    }
    return null;
  }
}

// 追加: eDoc (IC) の typedef
typedef RP_eDoc_GetMRZEx_Native =
    Int32 Function(Pointer<Int8>, Pointer<Int8>, Pointer<Int8>);
typedef RP_eDoc_GetMRZEx_Dart =
    int Function(Pointer<Int8>, Pointer<Int8>, Pointer<Int8>);

// （必要なら）読み取り結果の成否を取得
typedef RP_eDoc_GetResult_Native =
    Int32 Function(
      Pointer<Int32>,
      Pointer<Int32>,
      Pointer<Int32>,
      Pointer<Int32>,
      Pointer<Int32>,
      Pointer<Int32>,
    );
typedef RP_eDoc_GetResult_Dart =
    int Function(
      Pointer<Int32>,
      Pointer<Int32>,
      Pointer<Int32>,
      Pointer<Int32>,
      Pointer<Int32>,
      Pointer<Int32>,
    );

// 追加: lookup
final _rp_eDoc_GetMRZEx = _sdk
    .lookupFunction<RP_eDoc_GetMRZEx_Native, RP_eDoc_GetMRZEx_Dart>(
      'RP_eDoc_GetMRZEx',
    );
final _rp_eDoc_GetResult = _sdk
    .lookupFunction<RP_eDoc_GetResult_Native, RP_eDoc_GetResult_Dart>(
      'RP_eDoc_GetResult',
    );

// 追加: MRZ を氏名・国籍にパース（TD3想定）
Map<String, String> _parseMrzNameNat(String mrz1, String mrz2) {
  final nationality3 = (mrz2.length >= 13) ? mrz2.substring(10, 13) : '';
  String line = mrz1;
  if (line.length >= 5) {
    line = line.substring(5); // ここを常に5にする
  } else {
    line = '';
  }

  // "姓<<名" 形式。'<' は空白に置き換え
  final parts = line.split('<<');
  final family = parts.isNotEmpty ? parts[0].replaceAll('<', ' ').trim() : '';
  final given = parts.length > 1 ? parts[1].replaceAll('<', ' ').trim() : '';
  final fullName = (family.isNotEmpty && given.isNotEmpty)
      ? '$family $given'
      : (family.isNotEmpty ? family : given);

  // 必要に応じて3文字→国名のマップを当てる。ここではコードのまま返す
  final natName = nationality3;

  return {
    'name': fullName,
    'nationality': natName,
    'nationalityCode': nationality3,
  };
}
