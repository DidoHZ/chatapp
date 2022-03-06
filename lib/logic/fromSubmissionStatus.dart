import 'package:firebase_auth/firebase_auth.dart';

abstract class FormSubmissionStatus {
  const FormSubmissionStatus();
}

class InitialFormStatus extends FormSubmissionStatus {
  const InitialFormStatus();
}

class FormSubmitting extends FormSubmissionStatus {}

class SubmissionSuccess extends FormSubmissionStatus {}

class SubmissionFailed extends FormSubmissionStatus {
  final FirebaseAuthException? exception;
  
  SubmissionFailed(this.exception);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is SubmissionFailed &&
      other.exception == exception;
  }

  @override
  int get hashCode => exception.hashCode;
}
