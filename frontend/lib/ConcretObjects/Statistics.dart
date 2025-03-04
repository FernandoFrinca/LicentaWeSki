class Statistics {
  late int user_id;

  late double max_speed;
  late double total_distance;

  int getId(){
    return user_id;
  }

  double getMax_speed(){
    return max_speed;
  }

  double getTotal_distance(){
    return total_distance;
  }

  void setMax_speed(double max){
    max_speed = max;
  }

  void setTotal_distance(double total){
    total_distance = total;
  }

  @override
  String toString() {
    return 'id: $user_id, max_speed: $max_speed, total_distance: $total_distance \n';
  }
}
