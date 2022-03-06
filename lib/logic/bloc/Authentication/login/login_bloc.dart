import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '/data/repositories/AuthRepository.dart';
import '../../../fromSubmissionStatus.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepo;

  LoginBloc({required this.authRepo}) : super(LoginState()) {
    on<LoginEmailChanged>(
        (event, emit) => emit(state.copyWith(email: event.email)));
    on<LoginPasswordChanged>(
        (event, emit) => emit(state.copyWith(password: event.password)));
    on<LoginSubmitted>(_onSubmitted);
  }
  
  Future<void> _onSubmitted(
    LoginEvent event,
    Emitter<LoginState> emit
  ) async{
      try {
        emit(state.copyWith(formStatus: FormSubmitting()));
        await authRepo.connectEmailPassword(state.email, state.password);
        emit(state.copyWith(formStatus: SubmissionSuccess()));
      } on FirebaseAuthException catch (e, _) {
        emit(state.copyWith(formStatus: SubmissionFailed(e)));
      }
  }
}
