// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lecture_note.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LectureNoteAdapter extends TypeAdapter<LectureNote> {
  @override
  final int typeId = 2;

  @override
  LectureNote read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LectureNote(
      id: fields[0] as String,
      title: fields[1] as String,
      date: fields[2] as DateTime,
      course: fields[3] as String?,
      originalTranscript: fields[4] as String,
      translatedTranscript: fields[5] as String,
      images: (fields[6] as List).cast<VisualAid>(),
      keyTerms: (fields[7] as List).cast<KeyTerm>(),
      summaryPoints: (fields[8] as List).cast<String>(),
      duration: fields[9] as Duration,
      sourceLanguage: fields[10] as String,
      targetLanguage: fields[11] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LectureNote obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.course)
      ..writeByte(4)
      ..write(obj.originalTranscript)
      ..writeByte(5)
      ..write(obj.translatedTranscript)
      ..writeByte(6)
      ..write(obj.images)
      ..writeByte(7)
      ..write(obj.keyTerms)
      ..writeByte(8)
      ..write(obj.summaryPoints)
      ..writeByte(9)
      ..write(obj.duration)
      ..writeByte(10)
      ..write(obj.sourceLanguage)
      ..writeByte(11)
      ..write(obj.targetLanguage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LectureNoteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
