import 'dart:convert';

import 'package:sleepfy/models/question_model.dart';

TestModel testModelFromJson(String str) => TestModel.fromJson(json.decode(str));

String testModelToJson(TestModel data) => json.encode(data.toJson());

class TestModel {
  final int id;
  final String name;
  final List<Question> questions;

  TestModel({
    required this.id,
    required this.name,
    required this.questions,
  });

  factory TestModel.fromJson(Map<String, dynamic> json) => TestModel(
        id: json["id"],
        name: json["name"],
        questions: List<Question>.from(json["questions"].map((x) => Question.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "questions": List<dynamic>.from(questions.map((x) => x.toJson())),
      };
}
