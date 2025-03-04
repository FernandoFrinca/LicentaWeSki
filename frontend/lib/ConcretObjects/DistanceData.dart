import 'dart:ui';

class DistanceData {
  final String hour;
  final double distance;

  DistanceData(this.hour, this.distance);

  @override
  String toString() {
    return "hour: $hour -------> distance: $distance";
  }
}
