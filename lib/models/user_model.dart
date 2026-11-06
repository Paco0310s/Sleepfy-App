class UserModel {
  final int id;
  final String name;
  final String lastName;
  final String email;
  final String token;

  UserModel({
    required this.id,
    required this.name,
    required this.lastName,
    required this.email,
    this.token = '',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      lastName: json['lastName'],
      email: json['email'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'lastName': lastName,
      'email': email,
      'token': token,
    };
  }
}
