part of 'login_bloc.dart';

class LoginState {
  final String email;
  bool get isValidUsername => RegExp(r"[a-zA-Z][a-zA-Z0-9_.-]*@[a-zA-Z][a-zA-Z0-9_.-]+(.[a-zA-Z]+)+").firstMatch(email)?.group(0) != null;

  final String password;
  bool get isValidPassword => password.length > 6;

  final FormSubmissionStatus formStatus;

  LoginState({
    this.email = '',
    this.password = '',
    this.formStatus = const InitialFormStatus(),
  });

  LoginState copyWith({
    String? email,
    String? password,
    FormSubmissionStatus? formStatus,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      formStatus: formStatus ?? this.formStatus,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is LoginState &&
      other.email == email &&
      other.password == password &&
      other.formStatus == formStatus;
  }

  @override
  int get hashCode => email.hashCode ^ password.hashCode ^ formStatus.hashCode;
}
