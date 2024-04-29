import 'package:chat_application_iub_cse464/const_config/text_config.dart';
import 'package:chat_application_iub_cse464/models/user_model.dart';
import 'package:chat_application_iub_cse464/services/user_management_services.dart';
import 'package:chat_application_iub_cse464/widgets/chat_bubble.dart';
import 'package:chat_application_iub_cse464/widgets/custom_buttons/Rouded_Action_Button.dart';
import 'package:chat_application_iub_cse464/widgets/input_widgets/simple_input_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../const_config/color_config.dart';
import '../../../services/chat_service.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  final firebase = FirebaseFirestore.instance;
  final messageController = TextEditingController();
  final auth = FirebaseAuth.instance;
  List<UserData> users = [];

  @override
  void initState() {
    super.initState();
    // Call your asynchronous method here, not getUsers()
    UserManage().getUsers().then((userList) {
      setState(() {
        users = userList;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColor.scaffoldColor,
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: firebase.collection('chat').orderBy('time',descending: true).snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData && snapshot.connectionState == ConnectionState.active) {
                    var data = snapshot.data.docs;
                    return data.length != 0
                        ? ListView.builder(
                            itemCount: data.length,
                            reverse: true,
                            itemBuilder: (context, index) {
                              UserData user = users.firstWhere((user) => user.uuid == data[index]['uuid'], orElse: () => UserData());
                              return ChatBubble(
                                message: data[index]['message'],
                                isOwner: data[index]['uuid'].toString().compareTo(auth.currentUser!.uid.toString()) == 0,
                                username: user.name.toString(),
                              );
                            },
                          )
                        : const Center(child: Text("No Chats to show"));
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
            SimpleInputField(
              controller: messageController,
              hintText: "Aa..",
              needValidation: true,
              errorMessage: "Message box can't be empty",
              fieldTitle: "",
              needTitle: false,
            ),
            const SizedBox(
              height: 10,
            ),
            RoundedActionButton(
              onClick: () {
                ChatService().sendChatMessage(message: messageController.text);
              },
              label: "Send Message",
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ));
  }
}
