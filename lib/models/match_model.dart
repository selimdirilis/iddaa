// lib/models/match_model.dart
import 'package:hive/hive.dart';
part 'match_model.g.dart';

@HiveType(typeId: 0)
class MatchModel extends HiveObject {
  @HiveField(0)
  final String homeTeam;
  @HiveField(1)
  final String awayTeam;
  @HiveField(2)
  final double homeOdds;
  @HiveField(3)
  final double drawOdds;
  @HiveField(4)
  final double awayOdds;
  @HiveField(5)
  final DateTime date;

  MatchModel({
    required this.homeTeam,
    required this.awayTeam,
    required this.homeOdds,
    required this.drawOdds,
    required this.awayOdds,
    required this.date,
  });
}
