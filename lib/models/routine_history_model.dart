class RoutineHistoryModel {
  final int id;
  final String routine;
  final DateTime? createdAt;

  RoutineHistoryModel({
    required this.id,
    required this.routine,
    this.createdAt,
  });

  factory RoutineHistoryModel.fromJson(Map<String, dynamic> json) {
    return RoutineHistoryModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      routine: json['routine'] ?? '',
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'].toString()) : null,
    );
  }
}

