class User {
  int id;
  String username;
  String email;
  int? age;
  int? gender;
  String category;

  User({
    this.id = 0,
    this.username = '',
    this.email = '',
    this.age,
    this.gender,
    this.category = 'Not Set',
  });

  int getId(){
    return id;
  }

  String getUsername(){
    return username;
  }

  String getEmail(){
    return email;
  }

  int? getAge(){
    return age;
  }

  int? getGender(){
    return gender;
  }

  String getCategory(){
    return category;
  }
}
