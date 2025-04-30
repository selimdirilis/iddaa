// lib/models/match_model.g.dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_model.dart';

class MatchModelAdapter extends TypeAdapter<MatchModel> {
  @override
  final int typeId = 0;

  @override
  MatchModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MatchModel(
      homeTeam: fields[0] as String,
      awayTeam: fields[1] as String,
      homeOdds: fields[2] as double,
      drawOdds: fields[3] as double,
      awayOdds: fields[4] as double,
      date: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, MatchModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.homeTeam)
      ..writeByte(1)
      ..write(obj.awayTeam)
      ..writeByte(2)
      ..write(obj.homeOdds)
      ..writeByte(3)
      ..write(obj.drawOdds)
      ..writeByte(4)
      ..write(obj.awayOdds)
      ..writeByte(5)
      ..write(obj.date);
  }
}
