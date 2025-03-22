class ResortBotData {
  final String name;
  final double latitude;
  final double longitude;
  final List<SlopeBotData> slopes;

  ResortBotData({
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.slopes,
  });

  @override
  String toString() {
    return "{$name, $latitude, $longitude} -> $slopes \n";
  }
}

class SlopeBotData {
  final String name;
  final String difficulty;
  final List<List<double>> geom;

  SlopeBotData({
    required this.name,
    required this.difficulty,
    required this.geom,
  });

  @override
  String toString() {
    return "$geom";
  }
}