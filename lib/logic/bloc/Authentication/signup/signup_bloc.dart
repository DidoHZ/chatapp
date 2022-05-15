import 'package:bloc/bloc.dart';
import 'package:chatapp/constants/enums.dart';
import 'package:chatapp/constants/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '/data/repositories/AuthRepository.dart';
import '../../../fromSubmissionStatus.dart';
part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final AuthRepository authRepo;

  SignupBloc({required this.authRepo}) : super(SignupState()) {
    on<SignupUsernameChanged>(
        (event, emit) => emit(state.copyWith(username: event.username)));
    on<SignupEmailChanged>(
        (event, emit) => emit(state.copyWith(email: event.email)));
    on<SignupPasswordChanged>(
        (event, emit) => emit(state.copyWith(password: event.password)));
    on<SignupfirstNameChanged>(
        (event, emit) => emit(state.copyWith(firstName: event.firstName)));
    on<SignuplastNameChanged>(
        (event, emit) => emit(state.copyWith(lastName: event.lastName)));
    on<SignupSubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(
    SignupSubmitted event,
    Emitter<SignupState> emit,
  ) async{
    try {
        emit(state.copyWith(formStatus: FormSubmitting()));
        await authRepo.createAcount(state.email, state.password, state.username);
        emit(state.copyWith(formStatus: SubmissionSuccess()));
      } on FirebaseAuthException catch (e, _) {
        emit(state.copyWith(formStatus: SubmissionFailed(e)));
        emit(state.copyWith(formStatus: const InitialFormStatus()));
      }
  }
}
