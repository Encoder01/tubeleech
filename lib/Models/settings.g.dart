// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingsAdapter extends TypeAdapter<Settings> {
  @override
  final int typeId = 1;

  @override
  Settings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Settings(
      oneriler: fields[0] as bool,
      chosePlayer: fields[3] as bool,
      closeNtf: fields[1] as bool,
      usePlayer: fields[2] as bool,
      path: fields[4] as String,
      personelAds: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Settings obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.oneriler)
      ..writeByte(1)
      ..write(obj.closeNtf)
      ..writeByte(2)
      ..write(obj.usePlayer)
      ..writeByte(3)
      ..write(obj.chosePlayer)
      ..writeByte(4)
      ..write(obj.path)
      ..writeByte(5)
      ..write(obj.personelAds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
