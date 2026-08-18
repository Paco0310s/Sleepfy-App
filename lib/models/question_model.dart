import 'package:sleepfy/models/answer_options_model.dart';

class Question {
  final int id;
  final String question;
  final List<AnswersOption> answersOptions;

  Question({
    required this.id,
    required this.question,
    required this.answersOptions,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        id: json["id"],
        question: json["question"],
        answersOptions: List<AnswersOption>.from(json["AnswersOptions"].map((x) => AnswersOption.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "question": question,
        "AnswersOptions": List<dynamic>.from(answersOptions.map((x) => x.toJson())),
      };
}
