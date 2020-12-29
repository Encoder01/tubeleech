// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'videos.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VideosAdapter extends TypeAdapter<Videos> {
  @override
  final int typeId = 0;

  @override
  Videos read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Videos(
      id: fields[0] as String,
      isim: fields[1] as String,
      tur: fields[2] as String,
      yol: fields[3] as String,
      active: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Videos obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.isim)
      ..writeByte(2)
      ..write(obj.tur)
      ..writeByte(3)
      ..write(obj.yol)
      ..writeByte(4)
      ..write(obj.active);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideosAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
