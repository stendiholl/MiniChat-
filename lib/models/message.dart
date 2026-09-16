class Message {
  final int id;
  final int chatId;
  final String text;
  final DateTime time;
  final bool isMine;

  const Message({
    required this.id,
    required this.chatId,
    required this.text,
    required this.time,
    required this.isMine,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] ?? 0,
      chatId: json['chatId'] ?? 0,
      text: json['text'] ?? '',
      time: DateTime.tryParse(json['time'] ?? '') ?? DateTime.now(),
      isMine: json['isMine'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatId': chatId,
      'text': text,
      'time': time.toIso8601String(),
      'isMine': isMine,
    };
  }
}