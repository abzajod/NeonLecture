import 'package:hive/hive.dart';

part 'visual_aid.g.dart';

@HiveType(typeId: 0)
class VisualAid {
  @HiveField(0)
  final String keyword;
  @HiveField(1)
  final String imageUrl;
  @HiveField(2)
  final String caption;

  VisualAid({
    required this.keyword,
    required this.imageUrl,
    required this.caption,
  });
}

@HiveType(typeId: 1)
class KeyTerm {
  @HiveField(0)
  final String term;
  @HiveField(1)
  final String definition;

  KeyTerm({
    required this.term,
    required this.definition,
  });
}
