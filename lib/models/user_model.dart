class UserModel {
  final int id;
  final String name;
  final String lastName;
  final String email;
  final String token;
  final String refreshToken;
  final bool isAdmin;

  UserModel({
    required this.id,
    required this.name,
    required this.lastName,
    required this.email,
    this.token = '',
    this.refreshToken = '',
    this.isAdmin = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      token: json['token'] ?? json['access_token'] ?? '',
      refreshToken: json['refreshToken'] ?? json['refresh_token'] ?? '',
      isAdmin: json['isAdmin'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'lastName': lastName,
      'email': email,
      'token': token,
      'refreshToken': refreshToken,
      'isAdmin': isAdmin,
    };
  }
}
