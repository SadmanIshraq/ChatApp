import 'package:chatapp/features/auth/controller/auth_controller.dart';
import 'package:chatapp/features/chat/repositories/chat_repository.dart';
import 'package:chatapp/models/chat_contact.dart';
import 'package:chatapp/models/message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final chatControllerProvider= Provider(
        (ref){
          final chatRepository = ref.watch(chatRepositoryProvider);
        return ChatController(
        chatRepository: chatRepository,
        ref:ref,
        );
        }
);
class ChatController{
  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatController({
    required this.chatRepository,
    required this.ref});
  Stream<List<ChatContact>> chatContacts(){
    return chatRepository.getChatContacts();
  }
  Stream<List<Message>> chatStream(String recieverUserId){
    return chatRepository.getChatStream(recieverUserId);
  }
  void sendTextMessage(BuildContext context,String text,String recieverUserId,){
    ref.read(userDataAuthProvider).whenData((value) =>
    chatRepository.sendTextMessage(
        context: context,
        text: text,
        recieverUserId: recieverUserId,
        senderUser: value!),
    );
  }

}