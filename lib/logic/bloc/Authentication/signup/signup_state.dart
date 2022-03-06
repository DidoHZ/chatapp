part of 'signup_bloc.dart';

class SignupState {
  final String username;
  bool get isValidUsername => username.length > 4;

  final String email;
  bool get isValidEmail =>
      RegExp(emailRegex)
          .firstMatch(email)
          ?.group(0) !=
      null;

  final String password;
  bool get isValidPassword => password.length > 6;

  final String firstName;
  bool get isValidfirstName => password.length > 4;

  final String lastName;
  bool get isValidlastName => password.length > 4;

  final UserType? type;

  final FormSubmissionStatus formStatus;

  SignupState({
    this.username = '',
    this.email = '',
    this.password = '',
    this.firstName = '',
    this.lastName = '',
    this.type,
    this.formStatus = const InitialFormStatus(),
  });

  SignupState copyWith({
    String? username,
    String? email,
    String? password,
    String? firstName,
    String? lastName,
    UserType? type,
    FormSubmissionStatus? formStatus,
  }) {
    return SignupState(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      type: type ?? this.type,
      formStatus: formStatus ?? this.formStatus,
    );
  }


  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is SignupState &&
      other.username == username &&
      other.email == email &&
      other.password == password &&
      other.firstName == firstName &&
      other.lastName == lastName &&
      other.type == type &&
      other.formStatus == formStatus;
  }

  @override
  int get hashCode {
    return username.hashCode ^
      email.hashCode ^
      password.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      type.hashCode ^
      formStatus.hashCode;
  }
}
