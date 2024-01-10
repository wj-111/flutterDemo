class User {
  String username;
  String password;

  User({
    required this.username,
    required this.password,
  });

  factory User.fromJson(Map json) {
    return User(
      username: json['no'],
      password: json['name'],
    );
  }
}
