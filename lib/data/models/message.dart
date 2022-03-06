import 'dart:convert';

class Message {
  String date;
  String message;
  bool isSender;
  Message({
    required this.date,
    required this.message,
    required this.isSender,
  });


  Message copyWith({
    String? date,
    String? message,
    bool? isSender,
  }) {
    return Message(
      date: date ?? this.date,
      message: message ?? this.message,
      isSender: isSender ?? this.isSender,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'message': message,
      'isSender': isSender,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      date: map['date'] ?? '',
      message: map['message'] ?? '',
      isSender: map['isSender'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) => Message.fromMap(json.decode(source));

  @override
  String toString() => 'Message(date: $date, message: $message, isSender: $isSender)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Message &&
      other.date == date &&
      other.message == message &&
      other.isSender == isSender;
  }

  @override
  int get hashCode => date.hashCode ^ message.hashCode ^ isSender.hashCode;
}
