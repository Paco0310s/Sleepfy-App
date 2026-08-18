class SleepSchedule {
  final int id;
  final DateTime start;
  final DateTime end;
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  SleepSchedule({
    required this.id,
    required this.start,
    required this.end,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SleepSchedule.fromJson(Map<String, dynamic> json) => SleepSchedule(
        id: json["id"],
        start: DateTime.parse(json["start"]),
        end: DateTime.parse(json["end"]),
        userId: json["userId"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "start": start.toIso8601String(),
        "end": end.toIso8601String(),
        "userId": userId,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
