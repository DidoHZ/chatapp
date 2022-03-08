part of 'chats_cubit.dart';

class ChatsState {
  FormSubmissionStatus status;
  ValueNotifier<Map<User, ValueNotifier<List<Message>>>> chats = ValueNotifier({});

  ChatsState({
    this.status = const InitialFormStatus(),
  });

  ChatsState copyWith(
      {FormSubmissionStatus? status,
      ValueNotifier<Map<User, Stream<List<Message>>>>? chats}) {
    return ChatsState(
      status: status ?? this.status
    );
  }

  @override
  String toString() =>
      'ChatsState(status: $status, chats: $chats )';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatsState &&
        other.status == status &&
        other.chats == chats;
  }

  @override
  int get hashCode => status.hashCode ^ chats.hashCode;
}
