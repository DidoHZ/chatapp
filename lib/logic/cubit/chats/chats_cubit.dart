import 'package:bloc/bloc.dart';
import 'package:chatapp/data/models/message.dart';
import 'package:chatapp/data/models/user.dart';
import 'package:chatapp/data/repositories/chatRepository.dart';
import 'package:chatapp/logic/fromSubmissionStatus.dart';

part 'chats_state.dart';

class ChatsCubit extends Cubit<ChatsState> {
  final ChatRepository repo;
  String chatID = "";

  ChatsCubit({required this.repo}) : super(ChatsState());

  Future<void> getChats() async {
    emit(state.copyWith(status: FormSubmitting()));
    try {
      final users = repo.getUsers();
      
      final messages = repo.getUsers().asyncMap((event) async => {
        	for (var user in event) user.uid: repo.getchat(docID: await repo.getChatID(uid: user.uid))});
        	
      final lastmessages = repo.getUsers().asyncMap((event) async => {
        	for (var user in event) user.uid: repo.getlastchat(docID: await repo.getChatID(uid: user.uid))});

      emit(state.copyWith(
          status: SubmissionSuccess(), chats: users, messages: messages, lastmessages: lastmessages));
    } catch (e, _) {
      emit(state.copyWith(status: SubmissionFailed(null)));
    }
  }
  
  void initChatID(String uid) async => chatID = await repo.getChatID(uid: uid);

  Future<void> sendMessage(String message, String friendID) async {
    if (message == '') return;
    await repo.sendMessage(uid: friendID, message: message, chatID: chatID);
  }
}
