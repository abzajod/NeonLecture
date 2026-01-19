// lib/core/interop/stub_web_recorder_interop.dart

class MicRecorder {
  Future<String> start(int timesliceMs) async => '';
  void stop() {}
}

MicRecorder get micRecorder => MicRecorder();

set onMicData(Function callback) {}
