import 'package:bloc/bloc.dart';
import 'package:chatapp/core/Storage.dart';
import 'package:chatapp/logic/fromSubmissionStatus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  Storage storage = Storage.instance;

  ProfileCubit() : super(ProfileState());

  Future<void> uploadProfileImage() async {
    emit(state.copyWith(status: FormSubmitting()));

    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    final task = await (await storage.uploadImage(file,
            path: "Profiles", name: FirebaseAuth.instance.currentUser!.uid))
        ?.snapshotEvents
        .firstWhere((element) =>
            element.state == TaskState.success ||
            element.state == TaskState.error);

    bool succed = task != null && task.state == TaskState.success; 

    // If upload is succed So Submission is Done then load data from Server Storage
    // Otherwise Submission Faild and load data from cache
    emit(state.copyWith(status: succed ? SubmissionSuccess() : SubmissionFailed(null),loadFromCache: !succed));
  }
}
