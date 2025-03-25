class Friend {
  late int id;
  late String username;
  late String category;
  late double max_speed;
  late double total_distance;
  late String profile_picture = "empty";

  int getId(){
    return id;
  }

  String getUsername(){
    return username;
  }

  String getCategory(){
    return category;
  }

  String getProfilePicture(){
    return profile_picture;
  }

  @override
  String toString() {
    return 'id: $id, username: $username, category: $category, picture:  \n';
  }
}
