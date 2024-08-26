import 'package:chatapp/features/select_contacts/screens/select_contacts_screen.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/colors.dart';
import 'package:chatapp/features/chat/widgets/contacts_list.dart';

class MobileLayoutScreen extends StatelessWidget {
  const MobileLayoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.blue[200],
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.grey,
          centerTitle: false,
          title: const Text(
            'Chatify',
            style: TextStyle(
              fontSize: 24,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),

          bottom: const TabBar(
            indicatorColor: Colors.deepPurple,
            indicatorWeight: 6,
            labelColor: Colors.deepPurple,
            unselectedLabelColor: Colors.grey,

            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            tabs: [
              Tab(
                text: 'CHATS',

              ),
            ],
          ),
        ),
        body: const ContactsList(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, SelectContactsScreen.routeName);
          },
          backgroundColor: Colors.blue[800],
          child: const Icon(
            Icons.search,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
