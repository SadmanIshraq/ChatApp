import 'package:chatapp/common/enums/message_enum.dart';
import 'package:chatapp/common/utils/utils.dart';
import 'package:chatapp/models/chat_contact.dart';
import 'package:chatapp/models/message.dart';
import 'package:chatapp/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final chatRepositoryProvider= Provider(
        (ref)=>
            ChatRepository(
                firestore: FirebaseFirestore.instance,
                auth: FirebaseAuth.instance)
);
class ChatRepository{
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ChatRepository({
    required this.firestore,
    required this.auth,
  });
  Stream<List<ChatContact>>getChatContacts(){
    return firestore
    .collection('users')
    .doc(auth.currentUser!.uid)
    .collection('chats')
    .snapshots()
        .asyncMap((event) async{
      List<ChatContact>contacts=[];
      for(var document in event.docs){
       var chatContact=ChatContact.fromMap(document.data());
       var userData=await firestore
           .collection('users')
           .doc(chatContact.contactId)
           .get();
       var user=UserModel.fromMap(userData.data()!);
       contacts.add(ChatContact(name: user.name,
           profilePic: user.profilePic,
           contactId: chatContact.contactId,
           timeSent: chatContact.timeSent,
           lastMessage: chatContact.lastMessage));
      }
      return contacts;
    });
  }
  Stream<List<Message>>getChatStream(String recieverUserId) {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(recieverUserId)
        .collection('messages')
         .orderBy('timeSent')
        .snapshots()
        .map((event) {
          List<Message>messages=[];
          for(var document in event.docs){
            messages.add(Message.fromMap(document.data()));
          }
          return messages;
    });
  }
  void _saveDataToContactsSubcollection(
      UserModel senderUserData,
      UserModel recieverUserData,
      String text,
      DateTime timeSent,
      String recieverUserId,
      )async{
    var recieverChatContact = ChatContact(
        name: senderUserData.name,
        profilePic: senderUserData.profilePic,
        contactId: senderUserData.uid,
        timeSent: timeSent,
        lastMessage: text);
    await firestore.
    collection('users').
    doc(recieverUserId).
    collection('chats').
    doc(auth.currentUser!.uid).
    set(recieverChatContact.toMap());

    var senderChatContact = ChatContact(
        name: recieverUserData.name,
        profilePic: recieverUserData.profilePic,
        contactId: recieverUserData.uid,
        timeSent: timeSent,
        lastMessage: text);
    await firestore.
    collection('users').
    doc(auth.currentUser!.uid).
    collection('chats').
    doc(recieverUserId).
    set(senderChatContact.toMap());
  }
  void _saveMessageToMessageSubcollection(
  {required String recieverUserId,
  required String text,
  required DateTime timeSent,
  required String messageId,
  required String username,
  required recieverUsername,
  required MessageEnum messageType,
  }
      )async{
final message= Message(
  senderId: auth.currentUser!.uid,
    recieverid: recieverUserId,
    text: text,
    type: messageType,
    timeSent: timeSent,
    messageId: messageId,
);
await firestore
    .collection('users')
    .doc(auth.currentUser!.uid)
    .collection('chats')
    .doc(recieverUserId)
    .collection('messages')
    .doc(messageId)
    .set(message.toMap());
await firestore
    .collection('users')
    .doc(recieverUserId)
    .collection('chats')
    .doc(auth.currentUser!.uid)
    .collection('messages')
    .doc(messageId)
    .set(message.toMap());
  }
  void sendTextMessage({
  required BuildContext context,
  required String text,
    required String recieverUserId,
    required UserModel senderUser,
  })async{
   try {
     var timeSent=DateTime.now();
     UserModel recieverUserData;
     var userDataMap=
     await firestore.collection('users').doc(recieverUserId).get();
     recieverUserData =UserModel.fromMap(userDataMap.data()!);

     var messageId=const Uuid().v1();
     _saveDataToContactsSubcollection(
       senderUser,
       recieverUserData,
       text,
       timeSent,
       recieverUserId,
     );
     _saveMessageToMessageSubcollection(
       recieverUserId: recieverUserId,
       text: text,
       timeSent:timeSent,
       messageType: MessageEnum.text,
       messageId: messageId,
       recieverUsername: recieverUserData.name,
       username:senderUser.name,
     );
   }catch(e){
     showSnackBar(context: context, content: e.toString());
   }
  }
}