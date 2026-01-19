// web/recorder.js

window.micRecorder = {
  mediaRecorder: null,
  stream: null,
  sessionId: null,
  chunkIndex: 0,
  mimeType: null,

  start: async function (timesliceMs, onDataCallback) {
    try {
      // 1. Request Microphone Access
      const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
      this.stream = stream;
      this.sessionId = crypto.randomUUID();
      this.chunkIndex = 0;

      // 2. Select MIME Type
      let mimeType = 'audio/webm;codecs=opus';
      if (!MediaRecorder.isTypeSupported(mimeType)) {
        mimeType = 'audio/webm';
        if (!MediaRecorder.isTypeSupported(mimeType)) {
          mimeType = 'audio/ogg;codecs=opus'; // Firefox fallback
          if (!MediaRecorder.isTypeSupported(mimeType)) {
            mimeType = ''; // Let browser choose default
          }
        }
      }

      const options = mimeType ? { mimeType } : {};
      console.log(`Starting MediaRecorder with mimeType: ${mimeType || 'default'}`);

      // 3. Initialize MediaRecorder
      this.mediaRecorder = new MediaRecorder(stream, options);
      this.mimeType = this.mediaRecorder.mimeType || mimeType;

      // 4. Handle Data Available (Chunks)
      this.mediaRecorder.ondataavailable = async (event) => {
        if (event.data && event.data.size > 0) {
          const blob = event.data;
          const buffer = await blob.arrayBuffer();
          const uint8Array = new Uint8Array(buffer);

          // Pass data back to Dart
          // onDataCallback(data, mimeType, chunkIndex, sessionId)
          if (window.onMicData) {
            window.onMicData(uint8Array, this.mimeType, this.chunkIndex, this.sessionId);
          }
          this.chunkIndex++;
        }
      };

      // 5. Start Recording
      this.mediaRecorder.start(timesliceMs);
      return this.sessionId;

    } catch (err) {
      console.error("Error starting mic recorder:", err);
      throw err;
    }
  },

  stop: function () {
    if (this.mediaRecorder && this.mediaRecorder.state !== 'inactive') {
      this.mediaRecorder.stop();
    }
    if (this.stream) {
      this.stream.getTracks().forEach(track => track.stop());
    }
    this.mediaRecorder = null;
    this.stream = null;
    this.mimeType = null;
    console.log("Mic recorder stopped");
  }
};
