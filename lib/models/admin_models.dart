class AdminUserModel {
  final int id;
  final String name;
  final String lastName;
  final String email;
  final bool isEmailVerified;
  final bool isAdmin;
  final String? createdAt;

  AdminUserModel({
    required this.id,
    required this.name,
    required this.lastName,
    required this.email,
    required this.isEmailVerified,
    required this.isAdmin,
    this.createdAt,
  });

  String get fullName => '$name $lastName'.trim();

  String get initials {
    final first = name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : '';
    final last = lastName.trim().isNotEmpty ? lastName.trim()[0].toUpperCase() : '';
    final combined = '$first$last';
    return combined.isNotEmpty ? combined : 'U';
  }

  factory AdminUserModel.fromJson(Map<String, dynamic> json) {
    return AdminUserModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? '',
      lastName: json['lastName']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      isEmailVerified: json['isEmailVerified'] == true,
      isAdmin: json['isAdmin'] == true,
      createdAt: json['createdAt']?.toString(),
    );
  }
}

class AdminMetricsModel {
  final int totalUsers;
  final int verifiedUsers;
  final int totalAdmins;
  final int newUsersLast7Days;
  final int newUsersLast30Days;

  final int totalRoutines;
  final int totalUserAnswers;
  final int usersCompletedTest;
  final int totalSleepLogs;
  final int totalComments;

  final int totalKitProducts;
  final int activeKitProducts;
  final int lowStockProducts;
  final int activeContentItems;

  final List<AdminQuestionStatModel> testBreakdown;
  final List<AdminUserModel> recentUsers;

  AdminMetricsModel({
    required this.totalUsers,
    required this.verifiedUsers,
    required this.totalAdmins,
    required this.newUsersLast7Days,
    required this.newUsersLast30Days,
    required this.totalRoutines,
    required this.totalUserAnswers,
    required this.usersCompletedTest,
    required this.totalSleepLogs,
    required this.totalComments,
    required this.totalKitProducts,
    required this.activeKitProducts,
    required this.lowStockProducts,
    required this.activeContentItems,
    required this.testBreakdown,
    required this.recentUsers,
  });

  factory AdminMetricsModel.fromJson(Map<String, dynamic> json) {
    final users = (json['users'] as Map<String, dynamic>?) ?? {};
    final engagement = (json['engagement'] as Map<String, dynamic>?) ?? {};
    final catalog = (json['catalog'] as Map<String, dynamic>?) ?? {};
    final breakdownRaw = (json['testBreakdown'] as List?) ?? [];
    final recentRaw = (json['recentUsers'] as List?) ?? [];

    return AdminMetricsModel(
      totalUsers: (users['total'] as num?)?.toInt() ?? 0,
      verifiedUsers: (users['verified'] as num?)?.toInt() ?? 0,
      totalAdmins: (users['admins'] as num?)?.toInt() ?? 0,
      newUsersLast7Days: (users['newLast7Days'] as num?)?.toInt() ?? 0,
      newUsersLast30Days: (users['newLast30Days'] as num?)?.toInt() ?? 0,
      totalRoutines: (engagement['totalRoutines'] as num?)?.toInt() ?? 0,
      totalUserAnswers: (engagement['totalUserAnswers'] as num?)?.toInt() ?? 0,
      usersCompletedTest: (engagement['usersCompletedTest'] as num?)?.toInt() ?? 0,
      totalSleepLogs: (engagement['totalSleepLogs'] as num?)?.toInt() ?? 0,
      totalComments: (engagement['totalComments'] as num?)?.toInt() ?? 0,
      totalKitProducts: (catalog['totalKitProducts'] as num?)?.toInt() ?? 0,
      activeKitProducts: (catalog['activeKitProducts'] as num?)?.toInt() ?? 0,
      lowStockProducts: (catalog['lowStockProducts'] as num?)?.toInt() ?? 0,
      activeContentItems: (catalog['activeContentItems'] as num?)?.toInt() ?? 0,
      testBreakdown: breakdownRaw
          .whereType<Map<String, dynamic>>()
          .map(AdminQuestionStatModel.fromJson)
          .toList(),
      recentUsers: recentRaw
          .whereType<Map<String, dynamic>>()
          .map(AdminUserModel.fromJson)
          .toList(),
    );
  }
}

class AdminOptionStatModel {
  final int optionId;
  final String answer;
  final int count;
  final int percentage;

  AdminOptionStatModel({
    required this.optionId,
    required this.answer,
    required this.count,
    required this.percentage,
  });

  factory AdminOptionStatModel.fromJson(Map<String, dynamic> json) {
    return AdminOptionStatModel(
      optionId: (json['optionId'] as num?)?.toInt() ?? 0,
      answer: json['answer']?.toString() ?? '',
      count: (json['count'] as num?)?.toInt() ?? 0,
      percentage: (json['percentage'] as num?)?.toInt() ?? 0,
    );
  }
}

class AdminQuestionStatModel {
  final int questionId;
  final String question;
  final int totalResponses;
  final List<AdminOptionStatModel> options;

  AdminQuestionStatModel({
    required this.questionId,
    required this.question,
    required this.totalResponses,
    required this.options,
  });

  factory AdminQuestionStatModel.fromJson(Map<String, dynamic> json) {
    final rawOpts = (json['options'] as List?) ?? [];
    return AdminQuestionStatModel(
      questionId: (json['questionId'] as num?)?.toInt() ?? 0,
      question: json['question']?.toString() ?? '',
      totalResponses: (json['totalResponses'] as num?)?.toInt() ?? 0,
      options: rawOpts
          .whereType<Map<String, dynamic>>()
          .map(AdminOptionStatModel.fromJson)
          .toList(),
    );
  }
}

class AdminAnswerOptionModel {
  final int id;
  final String answer;

  AdminAnswerOptionModel({
    required this.id,
    required this.answer,
  });

  factory AdminAnswerOptionModel.fromJson(Map<String, dynamic> json) {
    return AdminAnswerOptionModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      answer: json['answer']?.toString() ?? '',
    );
  }
}

class AdminQuestionModel {
  final int id;
  final String question;
  final List<AdminAnswerOptionModel> options;

  AdminQuestionModel({
    required this.id,
    required this.question,
    required this.options,
  });

  factory AdminQuestionModel.fromJson(Map<String, dynamic> json) {
    final rawOptions = (json['AnswersOptions'] as List?) ?? [];
    return AdminQuestionModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      question: json['question']?.toString() ?? '',
      options: rawOptions
          .whereType<Map<String, dynamic>>()
          .map(AdminAnswerOptionModel.fromJson)
          .toList(),
    );
  }
}

class AdminTestModel {
  final int id;
  final String name;
  final List<AdminQuestionModel> questions;

  AdminTestModel({
    required this.id,
    required this.name,
    required this.questions,
  });

  factory AdminTestModel.fromJson(Map<String, dynamic> json) {
    final rawQuestions = (json['questions'] as List?) ?? [];
    return AdminTestModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? 'Evaluación de Sueño',
      questions: rawQuestions
          .whereType<Map<String, dynamic>>()
          .map(AdminQuestionModel.fromJson)
          .toList(),
    );
  }
}
