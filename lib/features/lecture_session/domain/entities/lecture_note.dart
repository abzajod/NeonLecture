import 'package:hive/hive.dart';
import 'visual_aid.dart';

part 'lecture_note.g.dart';

@HiveType(typeId: 2)
class LectureNote extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final DateTime date;
  @HiveField(3)
  final String? course;
  @HiveField(4)
  final String originalTranscript;
  @HiveField(5)
  final String translatedTranscript;
  @HiveField(6)
  final List<VisualAid> images;
  @HiveField(7)
  final List<KeyTerm> keyTerms;
  @HiveField(8)
  final List<String> summaryPoints;
  @HiveField(9)
  final Duration duration;
  @HiveField(10)
  final String sourceLanguage;
  @HiveField(11)
  final String targetLanguage;

  LectureNote({
    required this.id,
    required this.title,
    required this.date,
    this.course,
    required this.originalTranscript,
    required this.translatedTranscript,
    required this.images,
    required this.keyTerms,
    required this.summaryPoints,
    required this.duration,
    required this.sourceLanguage,
    required this.targetLanguage,
  });
}

