class Friend {
  late int id;
  late String username;
  late String category;
  late double max_speed;
  late double total_distance;

  int getId(){
    return id;
  }

  String getUsername(){
    return username;
  }

  String getCategory(){
    return category;
  }

  @override
  String toString() {
    return 'id: $id, username: $username, category: $category \n';
  }
}
