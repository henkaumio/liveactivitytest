import 'dart:developer';

import 'package:flutter/services.dart';

class DynamicIslandManager {
  final String channelKey;
  late final MethodChannel _methodChannel;

  DynamicIslandManager({required this.channelKey}) {
    _methodChannel = MethodChannel(channelKey);
  }

  Future<void> methodOne({required Map<String, dynamic> jsonData}) async {
    try {
      await _methodChannel.invokeListMethod('one', jsonData);
    } catch (e, st) {
      log(e.toString(), stackTrace: st);
    }
  }

  void startListening({Function? onPause, Function? onPlay}) {
    _methodChannel.setMethodCallHandler((call) async {
      if (call.method == 'play') {
        if (onPlay != null) {
          onPlay();
        }

        print('PLAY CALLED');
      } else if (call.method == 'pause') {
        if (onPause != null) {
          onPause();
        }
        print('PAUSE CALLED');
      }
    });
  }
}
