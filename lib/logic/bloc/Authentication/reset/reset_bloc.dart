import 'package:bloc/bloc.dart';
import 'package:chatapp/constants/strings.dart';
import 'package:chatapp/data/repositories/AuthRepository.dart';
import 'package:chatapp/logic/fromSubmissionStatus.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'reset_event.dart';
part 'reset_state.dart';

class ResetBloc extends Bloc<ResetEvent, ResetState> {
  final AuthRepository authRepo;

  ResetBloc({required this.authRepo}) : super(ResetState()) {
    on<ResetEmailSubmitted>(_onResetVerifyEmailSubmitted);
  }

 Future<void> _onResetVerifyEmailSubmitted(
    ResetEvent event,
    Emitter<ResetState> emit
  ) async{
  try {
        emit(state.copyWith(formStatus: FormSubmitting()));
        await authRepo.restPassword(state.email);
        emit(state.copyWith(formStatus: SubmissionSuccess()));
      } on FirebaseAuthException catch (e, _) {
        emit(state.copyWith(formStatus: SubmissionFailed(e)));
      }
  }

}