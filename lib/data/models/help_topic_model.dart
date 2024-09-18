class HelpTopic {
  final String question;
  final String answer;
  bool isExpanded;

  HelpTopic({
    required this.question,
    required this.answer,
    this.isExpanded = false,
  });

  factory HelpTopic.fromJson(Map<String, dynamic> json) {
    return HelpTopic(
      question: json['question'],
      answer: json['answer'],
    );
  }
}