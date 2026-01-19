@JS()
library web_recorder_interop;

import 'dart:js_interop';

/// JS Object reference to window.micRecorder
@JS('micRecorder')
external MicRecorder get micRecorder;

@JS()
extension type MicRecorder._(JSObject _) implements JSObject {
  external JSPromise<JSString> start(int timesliceMs);
  external void stop();
}

/// JS Object reference to window.onMicData
@JS('onMicData')
external set onMicData(JSFunction callback);

/// Callback signature: (Uint8List data, String mimeType, int index, String sessionId)
typedef OnMicDataCallback = void Function(
    JSObject data, JSString mimeType, JSNumber index, JSString sessionId);
