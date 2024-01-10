class QnA {
  String id;
  String question;
  List<String> answers;

  QnA({
    required this.id,
    required this.question,
    required this.answers,
  });

  // // Named constructor for creating QnA from JSON map
  // QnA.fromJson(Map<String, dynamic> json)
  //     : question = json['question'],
  //       answers = List<String>.from(json['answers'] ?? []);

  // void addAnswer(String newAnswer) {
  //   answers.add(newAnswer);
  // }
  // Named constructor for creating QnA from JSON map
  factory QnA.fromJson(Map<String, dynamic> json) {
    return QnA(
      id: json['id'] ?? '',
      question: json['question'] ?? '',
      answers: List<String>.from(json['answers'] ?? []),
    );
  }
  // QnA.fromJson(Map<String, dynamic> json)
  //     : id = json['id'],
  //       question = json['question'],
  //       answers = List<String>.from(json['answers'] ?? []);

  Map<String, dynamic> toJson() => {
        'id': id,
        'question': question,
        'answers': answers,
      };

  void addAnswer(String newAnswer) {
    answers.add(newAnswer);
  }
}
