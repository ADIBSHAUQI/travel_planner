class QnA {
  String id;
  String question;
  List<String> answers;

  QnA({
    required this.id,
    required this.question,
    required this.answers,
  });

  // constructor for creating QnA from JSON map
  factory QnA.fromJson(Map<String, dynamic> json) {
    return QnA(
      id: json['id'] ?? '',
      question: json['question'] ?? '',
      answers: List<String>.from(json['answers'] ?? []),
    );
  }
}
