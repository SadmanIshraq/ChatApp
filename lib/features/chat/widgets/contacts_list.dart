import 'package:chatapp/common/widgets/loader.dart';
import 'package:chatapp/features/chat/controller/chat_controller.dart';
import 'package:chatapp/models/chat_contact.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/colors.dart';
import 'package:chatapp/info.dart';
import 'package:chatapp/features/chat/screens/mobile_chat_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ContactsList extends ConsumerWidget {
  const ContactsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: StreamBuilder<List<ChatContact>>(
        stream: ref.watch(chatControllerProvider).chatContacts(),
        builder: (context,snapshot) {
          if (snapshot.connectionState==ConnectionState.waiting) {
            return const Loader();
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var chatContactData=snapshot.data![index];
              return Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                       context,
                        MobileChatScreen.routeName,
                        arguments:{
                         'name':chatContactData.name,
                          'uid':chatContactData.contactId,
                        }
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ListTile(
                        title: Text(
                          chatContactData.name,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Text(
                            chatContactData.lastMessage,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            chatContactData.profilePic,
                          ),
                          radius: 30,
                        ),
                        trailing: Text(
                          DateFormat.Hm().format(chatContactData.timeSent),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Divider(color: dividerColor, indent: 85),
                ],
              );
            },
          );
        }
      ),
    );
  }
}
