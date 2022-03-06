part of 'reset_bloc.dart';

abstract class ResetEvent {
  final String email;

  const ResetEvent(this.email);
}

class ResetEmailSubmitted implements ResetEvent {
  @override
  final String email;

  ResetEmailSubmitted({required this.email});
}
