part of 'reset_bloc.dart';

class ResetState {
  final String email;
  bool get isValidEmail =>
      RegExp(emailRegex)
          .firstMatch(email)
          ?.group(0) !=
      null;

  final String code;
  bool get isValidCode =>
      RegExp(r"([0-9]+){6}")
          .firstMatch(email)
          ?.group(0) !=
      null;

  final String password;
  bool get isValidPassword => password.length > 6;

  final FormSubmissionStatus formStatus;

  ResetState({
    this.email = '',
    this.code = '',
    this.password = '',
    this.formStatus = const InitialFormStatus(),
  });

  ResetState copyWith({
    String? email,
    String? code,
    String? password,
    FormSubmissionStatus? formStatus,
  }) {
    return ResetState(
      email: email ?? this.email,
      code: code ?? this.code,
      password: password ?? this.password,
      formStatus: formStatus ?? this.formStatus,
    );
  }


  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ResetState &&
      other.email == email &&
      other.code == code &&
      other.password == password &&
      other.formStatus == formStatus;
  }

  @override
  int get hashCode {
    return email.hashCode ^
      code.hashCode ^
      password.hashCode ^
      formStatus.hashCode;
  }
}
