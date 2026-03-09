import 'package:openim_sdk/openim_sdk.dart';

class OpenIMService {
  OpenIMService._();

  static final OpenIMService instance = OpenIMService._();

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    await OpenIM.iMManager.initSDK(
      platform: IMPlatform.android,
      apiAddr: 'https://api.placeholder.com',
      wsAddr: 'wss://ws.placeholder.com',
      objectStorage: 'minio',
      dataDir: '',
      logLevel: 6,
      isLogStandardOutput: true,
    );
    _initialized = true;
  }
}
