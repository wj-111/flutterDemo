class UserQuery {
  final String phone;
  final String password;

  UserQuery({required this.phone, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'password': password,
    };
  }
}
