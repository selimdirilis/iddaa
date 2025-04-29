class MatchModel {
  final Map<String, String> data;

  MatchModel({required this.data});

  factory MatchModel.fromMap(Map<String, dynamic> map) {
    return MatchModel(
      data: map.map((key, value) => MapEntry(key, value?.toString() ?? '')),
    );
  }
}
