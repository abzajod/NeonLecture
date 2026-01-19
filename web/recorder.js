// web/recorder.js

window.micRecorder = {
  mediaRecorder: null,
  stream: null,
  sessionId: null,
  chunkIndex: 0,
  mimeType: null,
  WEBHOOK_URL: 'https://nonmediative-suitably-ellen.ngrok-free.dev/webhook-test/neon-lecture',

  start: async function (timesliceMs) {
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
            mimeType = 'audio/webm'; // Force webm
          }
        }
      }

      const options = mimeType ? { mimeType } : {};
      this.mimeType = mimeType;
      console.log("🎤 mic start", mimeType);

      // 3. Initialize MediaRecorder
      this.mediaRecorder = new MediaRecorder(stream, options);

      // 4. Handle Data Available (Chunks)
      this.mediaRecorder.ondataavailable = async (event) => {
        if (event.data && event.data.size > 0) {
          const blob = event.data;
          console.log("📦 chunk", this.chunkIndex, "size:", blob.size, "bytes");

          // Upload directly from JS
          await this.uploadChunk(blob);
          this.chunkIndex++;
        }
      };

      // 5. Start Recording with 1500ms timeslice
      this.mediaRecorder.start(1500);
      return this.sessionId;

    } catch (err) {
      console.error("❌ Error starting mic recorder:", err);
      throw err;
    }
  },

  uploadChunk: async function (blob) {
    try {
      const fd = new FormData();
      fd.append("audio", blob, `chunk_${this.chunkIndex}.webm`);
      fd.append("chunkIndex", String(this.chunkIndex));
      fd.append("sessionId", this.sessionId);
      fd.append("mimeType", this.mimeType);
      fd.append("source_lang", "en");
      fd.append("target_lang", "ar");

      console.log("🚀 POST to", this.WEBHOOK_URL, "chunk", this.chunkIndex);

      const response = await fetch(this.WEBHOOK_URL, {
        method: "POST",
        body: fd
      });

      console.log("✅ Response", response.status, "for chunk", this.chunkIndex);

      const data = await response.json();
      console.log("📝 Response data:", data);

      // Update UI via Dart callback if available
      if (window.onMicData) {
        window.onMicData(data.script || "", data.translation || "");
      }

    } catch (err) {
      console.error("❌ Upload error for chunk", this.chunkIndex, ":", err);
    }
  },

  stop: function () {
    console.log("⏹️ Stopping recorder");
    if (this.mediaRecorder && this.mediaRecorder.state !== 'inactive') {
      this.mediaRecorder.stop();
    }
    if (this.stream) {
      this.stream.getTracks().forEach(track => track.stop());
    }
    this.mediaRecorder = null;
    this.stream = null;
    this.mimeType = null;
    console.log("✅ Mic recorder stopped");
  }
};
