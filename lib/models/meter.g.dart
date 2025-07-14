// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meter.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MeterAdapter extends TypeAdapter<Meter> {
  @override
  final int typeId = 0;

  @override
  Meter read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Meter(
      serialNumber: fields[0] as String,
      location: fields[1] as String,
      isActive: fields[2] as bool,
      lastUpdate: fields[3] as DateTime,
      reading: fields[4] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Meter obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.serialNumber)
      ..writeByte(1)
      ..write(obj.location)
      ..writeByte(2)
      ..write(obj.isActive)
      ..writeByte(3)
      ..write(obj.lastUpdate)
      ..writeByte(4)
      ..write(obj.reading);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MeterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
