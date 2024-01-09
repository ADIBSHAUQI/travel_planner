class QnA {
  final String question;
  List<String> answers;

  QnA({required this.question, List<String>? answers})
      : this.answers = answers ?? [];

  void addAnswer(String newAnswer) {
    answers.add(newAnswer);
  }
}
