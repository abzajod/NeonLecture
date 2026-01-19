import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'audio_recording_service.dart';
import 'audio_chunker.dart';
import 'n8n_service.dart';
import '../../domain/entities/visual_aid.dart';
import '../../domain/entities/lecture_note.dart';
import '../../../lecture_library/data/repositories/lecture_repository.dart';

/// Provider for the AudioRecordingService
final audioServiceProvider = Provider((ref) => AudioRecordingService());

/// Provider for n8n Service
final n8nServiceProvider = Provider((ref) => N8nService());

/// Provider for LectureRepository
final lectureRepositoryProvider = Provider((ref) => LectureRepository());

/// Provider for the SessionManager
final sessionManagerProvider = StateNotifierProvider<SessionManager, SessionState>((ref) {
  final audioService = ref.watch(audioServiceProvider);
  final n8nService = ref.watch(n8nServiceProvider);
  final repository = ref.watch(lectureRepositoryProvider);
  return SessionManager(audioService, n8nService, repository);
});

/// State for the lecture session
class SessionState {
  final String? sessionId;
  final bool isRecording;
  final bool isPaused;
  final Duration duration;
  final List<String> transcript;
  final List<String> translatedText;
  final List<VisualAid> visualAids;
  final String? errorMessage;

  SessionState({
    this.sessionId,
    this.isRecording = false,
    this.isPaused = false,
    this.duration = Duration.zero,
    this.transcript = const [],
    this.translatedText = const [],
    this.visualAids = const [],
    this.errorMessage,
  });

  SessionState copyWith({
    String? sessionId,
    bool? isRecording,
    bool? isPaused,
    Duration? duration,
    List<String>? transcript,
    List<String>? translatedText,
    List<VisualAid>? visualAids,
    String? errorMessage,
  }) {
    return SessionState(
      sessionId: sessionId ?? this.sessionId,
      isRecording: isRecording ?? this.isRecording,
      isPaused: isPaused ?? this.isPaused,
      duration: duration ?? this.duration,
      transcript: transcript ?? this.transcript,
      translatedText: translatedText ?? this.translatedText,
      visualAids: visualAids ?? this.visualAids,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// Coordinates the recording session lifecycle
class SessionManager extends StateNotifier<SessionState> {
  final AudioRecordingService _audioService;
  final N8nService _n8nService;
  final LectureRepository _repository;
  AudioChunker? _chunker;
  Timer? _durationTimer;
  StreamSubscription? _chunkSubscription;

  SessionManager(this._audioService, this._n8nService, this._repository) : super(SessionState());

  /// Start a new lecture session
  Future<void> startSession() async {
    final sessionId = const Uuid().v4();
    
    try {
      await _audioService.startRecording();
      
      _chunker = AudioChunker(_audioService);
      _chunker?.start();
      
      _chunkSubscription = _chunker?.chunkedStream.listen(_onAudioChunkReceived);
      
      _startDurationTimer();
      
      state = state.copyWith(
        sessionId: sessionId,
        isRecording: true,
        isPaused: false,
        duration: Duration.zero,
        transcript: [],
        translatedText: [],
      );
    } catch (e) {
      // Handle recording start error
      rethrow;
    }
  }

  /// Stop the current session
  Future<void> stopSession() async {
    await _audioService.stopRecording();
    _chunker?.stop();
    _durationTimer?.cancel();
    _chunkSubscription?.cancel();
    
    state = state.copyWith(isRecording: false, isPaused: false);
  }

  /// Pause current session
  Future<void> pauseSession() async {
    await _audioService.pauseRecording();
    _durationTimer?.cancel();
    state = state.copyWith(isPaused: true);
  }

  /// Resume current session
  Future<void> resumeSession() async {
    await _audioService.resumeRecording();
    _startDurationTimer();
    state = state.copyWith(isPaused: false);
  }

  void _onAudioChunkReceived(dynamic chunk) async {
    print("Received audio chunk for session ${state.sessionId}, size: ${chunk.length}");
    
    try {
      final response = await _n8nService.sendAudioChunk(
        sessionId: state.sessionId ?? '',
        audioData: chunk,
        sourceLang: 'en', // TODO: Get from settings
        targetLang: 'ar', // TODO: Get from settings
      );

      final originalText = response['original_text'] as String?;
      final translatedText = response['translated_text'] as String?;

      if (originalText != null && originalText.isNotEmpty) {
        state = state.copyWith(
          transcript: [...state.transcript, originalText],
          translatedText: [...state.translatedText, translatedText ?? '...'],
        );
        
        // Phase 5: Check for keywords in the new original text
        _checkForKeywords(originalText);
      }
    } catch (e) {
      print("Error processing audio chunk: $e");
    }
  }

  void _checkForKeywords(String text) async {
    // Simple mock keyword extraction for now
    // In Phase 3, n8n will handle this
    final keywords = ['atom', 'nucleus', 'cell', 'dna', 'gravity']
        .where((k) => text.toLowerCase().contains(k.toLowerCase()))
        .toList();

    if (keywords.isNotEmpty) {
      final aids = await _n8nService.fetchVisualAids(
        sessionId: state.sessionId ?? '',
        keywords: keywords,
      );
      
      if (aids.isNotEmpty) {
        final newAids = aids.map((a) => VisualAid(
          keyword: a['keyword'] ?? '',
          imageUrl: a['image_url'] ?? '',
          caption: a['caption'] ?? '',
        )).toList();

        state = state.copyWith(
          visualAids: [...state.visualAids, ...newAids],
        );
      }
    }
  }

  /// Finalize the session and generate notes
  Future<LectureNote?> finalizeSession() async {
    try {
      await stopSession();
      
      // In Phase 3, we would call:
      // final summary = await _n8nService.generateSummary(...);
      
      // For now, return a mock LectureNote
      final note = LectureNote(
        id: state.sessionId ?? "",
        title: "Lecture on ${DateTime.now().toIso8601String()}",
        date: DateTime.now(),
        originalTranscript: state.transcript.join("\n"),
        translatedTranscript: state.translatedText.join("\n"),
        images: state.visualAids,
        keyTerms: [], // Placeholder
        summaryPoints: ["Main point 1", "Main point 2"], // Placeholder
        duration: state.duration,
        sourceLanguage: "en",
        targetLanguage: "ar",
      );
      
      // Save lecture to local database
      await _repository.saveLecture(note);
      
      return note;
    } catch (e) {
      debugPrint("Error finalizing session: $e");
      return null;
    }
  }

  void _startDurationTimer() {
    _durationTimer?.cancel();
    _durationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      state = state.copyWith(duration: state.duration + const Duration(seconds: 1));
    });
  }

  @override
  void dispose() {
    _durationTimer?.cancel();
    _chunkSubscription?.cancel();
    _chunker?.dispose();
    super.dispose();
  }
}
