// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'musics.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MusicsAdapter extends TypeAdapter<Musics> {
  @override
  final int typeId = 2;

  @override
  Musics read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Musics(
      id: fields[0] as String,
      isim: fields[1] as String,
      tur: fields[2] as String,
      yol: fields[3] as String,
      active: fields[4] as bool,
      thumbnail: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Musics obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.isim)
      ..writeByte(2)
      ..write(obj.tur)
      ..writeByte(3)
      ..write(obj.yol)
      ..writeByte(4)
      ..write(obj.active)
      ..writeByte(5)
      ..write(obj.thumbnail);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MusicsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
