part of 'chats_cubit.dart';

class ChatsState {
  Stream<List<User>>? chats;
  FormSubmissionStatus status;
  Stream<Map<String, Stream<List<Message>>>>? messages;
  Stream<Map<String, Stream<List<Message>>>>? lastmessages;

  ChatsState({
    this.chats,
    this.status = const InitialFormStatus(),
    this.messages,
    this.lastmessages
  });

  ChatsState copyWith({
    Stream<List<User>>? chats,
    FormSubmissionStatus? status,
    Stream<Map<String, Stream<List<Message>>>>? messages,
    Stream<Map<String, Stream<List<Message>>>>? lastmessages
  }) {
    return ChatsState(
      chats: chats ?? this.chats,
      status: status ?? this.status,
      messages: messages ?? this.messages,
      lastmessages: lastmessages ?? lastmessages
    );
  }

  @override
  String toString() =>
      'ChatsState(chats: $chats, status: $status, messages: $messages, lastmessages: $lastmessages)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatsState &&
        other.chats == chats &&
        other.status == status &&
        other.messages == messages &&
        other.lastmessages == lastmessages;
  }

  @override
  int get hashCode => chats.hashCode ^ status.hashCode ^ messages.hashCode ^ lastmessages.hashCode;
}
