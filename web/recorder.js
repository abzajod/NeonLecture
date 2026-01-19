// web/recorder.js

window.micRecorder = {
  mediaRecorder: null,
  stream: null,
  sessionId: null,
  chunkIndex: 0,
  mimeType: null,
  recordedChunks: [],
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

      // 4. Handle Data Available (Chunks) - Store chunks instead of uploading
      this.mediaRecorder.ondataavailable = (event) => {
        if (event.data && event.data.size > 0) {
          this.recordedChunks.push(event.data);
          console.log("📦 chunk", this.chunkIndex, "size:", event.data.size, "bytes (stored)");
          this.chunkIndex++;
        }
      };

      // Handle recording stop - finalize and upload
      this.mediaRecorder.onstop = async () => {
        await this.finalizeRecording();
      };

      // 5. Start Recording with 1500ms timeslice
      this.mediaRecorder.start(1500);
      return this.sessionId;

    } catch (err) {
      console.error("❌ Error starting mic recorder:", err);
      throw err;
    }
  },

  finalizeRecording: async function () {
    console.log("🏁 Finalizing recording...");

    if (this.recordedChunks.length === 0) {
      console.warn("⚠️ No audio chunks recorded");
      return;
    }

    // Merge all chunks into a single blob
    const fullBlob = new Blob(this.recordedChunks, { type: this.mimeType });

    if (fullBlob.size === 0) {
      console.warn("⚠️ Recording is empty (0 bytes)");
      return;
    }

    console.log("🎯 Complete recording:", fullBlob.size, "bytes from", this.recordedChunks.length, "chunks");

    // Upload the complete recording
    await this.uploadRecording(fullBlob);

    // Clear chunks after upload
    this.recordedChunks = [];
  },

  uploadRecording: async function (blob) {
    try {
      const fd = new FormData();
      fd.append("audio", blob, `recording_${this.sessionId}.webm`);
      fd.append("sessionId", this.sessionId);
      fd.append("mimeType", this.mimeType);
      fd.append("source_lang", "en");
      fd.append("target_lang", "ar");
      fd.append("totalSize", String(blob.size));

      console.log("🚀 POST complete recording to", this.WEBHOOK_URL);
      console.log("   Size:", blob.size, "bytes");
      console.log("   Session:", this.sessionId);

      const response = await fetch(this.WEBHOOK_URL, {
        method: "POST",
        body: fd
      });

      console.log("✅ Response", response.status, "for complete recording");

      const data = await response.json();
      console.log("📝 Response data:", data);

      // Update UI via Dart callback if available
      if (window.onMicData) {
        window.onMicData(data.script || "", data.translation || "");
      }

    } catch (err) {
      console.error("❌ Upload error for recording:", err);
    }
  },

  stop: function () {
    console.log("⏹️ Stopping recorder");
    if (this.mediaRecorder && this.mediaRecorder.state !== 'inactive') {
      // This will trigger onstop which will call finalizeRecording
      this.mediaRecorder.stop();
    }
    if (this.stream) {
      this.stream.getTracks().forEach(track => track.stop());
    }
    this.mediaRecorder = null;
    this.stream = null;
    this.mimeType = null;
    this.chunkIndex = 0;
    console.log("✅ Mic recorder stopped");
  }
};
