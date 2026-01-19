import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../lecture_session/domain/entities/lecture_note.dart';
import '../../../lecture_session/domain/entities/visual_aid.dart';

class LectureRepository {
  static const String _boxName = 'lectures';

  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(VisualAidAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(KeyTermAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(LectureNoteAdapter());
    }

    await Hive.openBox<LectureNote>(_boxName);
  }

  Box<LectureNote> get _box => Hive.box<LectureNote>(_boxName);

  Future<void> saveLecture(LectureNote lecture) async {
    await _box.put(lecture.id, lecture);
  }

  ValueListenable<Box<LectureNote>> get lecturesListenable => _box.listenable();

  List<LectureNote> getAllLectures() {
    return _box.values.toList()..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> deleteLecture(String id) async {
    await _box.delete(id);
  }

  Future<void> clearAll() async {
    await _box.clear();
  }
}
