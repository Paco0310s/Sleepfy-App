
class AnswersOption {
    final int id;
    final String answer;

    AnswersOption({
        required this.id,
        required this.answer,
    });

    factory AnswersOption.fromJson(Map<String, dynamic> json) => AnswersOption(
        id: json["id"],
        answer: json["answer"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "answer": answer,
    };
}
