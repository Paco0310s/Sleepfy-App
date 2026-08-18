class CommentModel {
  final int id;
  final String comment;
  final int userId;
  final DateTime createdAt;
  final UserComment user;

  CommentModel({
    required this.id,
    required this.comment,
    required this.userId,
    required this.createdAt,
    required this.user,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        id: json["id"],
        comment: json["comment"],
        userId: json["userId"],
        createdAt: DateTime.parse(json["createdAt"]),
        user: UserComment.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "comment": comment,
        "userId": userId,
        "createdAt": createdAt.toIso8601String(),
        "user": user.toJson(),
      };
}

class UserComment {
  final String name;
  final String lastName;

  UserComment({
    required this.name,
    required this.lastName,
  });

  factory UserComment.fromJson(Map<String, dynamic> json) => UserComment(
        name: json["name"],
        lastName: json["lastName"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "lastName": lastName,
      };
}
