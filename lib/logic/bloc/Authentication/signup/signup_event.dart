part of 'signup_bloc.dart';

abstract class SignupEvent {}

class SignupUsernameChanged extends SignupEvent {
  final String username;

  SignupUsernameChanged({required this.username});
}

class SignupEmailChanged extends SignupEvent {
  final String email;

  SignupEmailChanged({required this.email});
}

class SignupPasswordChanged extends SignupEvent {
  final String password;

  SignupPasswordChanged({required this.password});
}

class SignupfirstNameChanged extends SignupEvent {
  final String firstName;

  SignupfirstNameChanged({required this.firstName});
}

class SignuplastNameChanged extends SignupEvent {
  final String lastName;

  SignuplastNameChanged({required this.lastName});
}

class SignuptypeChanged extends SignupEvent {
  final UserType type;

  SignuptypeChanged({required this.type});
}

class SignupSubmitted extends SignupEvent {}