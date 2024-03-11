// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personas.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PersonasAdapter extends TypeAdapter<Personas> {
  @override
  final int typeId = 0;

  @override
  Personas read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Personas(
      nombre: fields[0] as String,
      apellido: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Personas obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.nombre)
      ..writeByte(1)
      ..write(obj.apellido);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PersonasAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
