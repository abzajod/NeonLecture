// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visual_aid.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VisualAidAdapter extends TypeAdapter<VisualAid> {
  @override
  final int typeId = 0;

  @override
  VisualAid read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VisualAid(
      keyword: fields[0] as String,
      imageUrl: fields[1] as String,
      caption: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, VisualAid obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.keyword)
      ..writeByte(1)
      ..write(obj.imageUrl)
      ..writeByte(2)
      ..write(obj.caption);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VisualAidAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class KeyTermAdapter extends TypeAdapter<KeyTerm> {
  @override
  final int typeId = 1;

  @override
  KeyTerm read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return KeyTerm(
      term: fields[0] as String,
      definition: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, KeyTerm obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.term)
      ..writeByte(1)
      ..write(obj.definition);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KeyTermAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
