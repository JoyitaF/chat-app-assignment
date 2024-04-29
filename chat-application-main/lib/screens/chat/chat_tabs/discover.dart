import 'package:chat_application_iub_cse464/const_config/color_config.dart';
import 'package:chat_application_iub_cse464/const_config/text_config.dart';
import 'package:chat_application_iub_cse464/models/message_model.dart';
import 'package:chat_application_iub_cse464/models/user_model.dart';
import 'package:chat_application_iub_cse464/services/user_management_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:random_avatar/random_avatar.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({Key? key}) : super(key: key);

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  List<UserData> users = [];

  @override
  void initState() {
    super.initState();
    // asynchronous init
    UserManage().getUsers().then((userList) {
      setState(() {
        users = userList;
      });
    });
  }
  
Future<String?> getMostRecentMessageTime(String userId) async {
  List<MessageModel> chats = [];
  //get list of chats
  try {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('chat').get();
    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      chats.add(MessageModel.fromMap(data));
    }
  } catch (e) {}

  // list of match userId
  List<MessageModel> userMessages =
      chats.where((message) => message.uuid == userId).toList();

  if (userMessages.isNotEmpty) {
    // sort in descending time
    userMessages.sort((a, b) => b.time!.compareTo(a.time!));
    
    MessageModel mostRecentMessage = userMessages.first;

    DateTime dateTime = mostRecentMessage.time!.toDate();

    // format the timestamp using the intl package
    String formattedTime = DateFormat.yMd().add_jm().format(dateTime);

    return formattedTime;
  } else {
    return null;
  }
}


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Our App Users:',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: MyColor.purpleLight,
          ),
        ),
        Expanded(
          child: Scaffold(
            backgroundColor: MyColor.scaffoldColor,
            body: Center(
              child: users.isNotEmpty
                  ? ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        UserData user = users[index];
                        return Card(
                          color: MyColor.purple10,
                          elevation: 2,
                          child: ListTile(
                            leading: RandomAvatar(
                              user.name.toString(),
                              trBackground: false,
                              height: 40,
                              width: 40,
                            ),
                            title: Text(user.name ?? 'No Name', style: TextStyle(color: MyColor.deepBlue),),
                            subtitle: Text(user.email ?? 'No Email'),
                            trailing: SizedBox( 
                              width: 60,
                              child: FutureBuilder<String?>(
                                future: getMostRecentMessageTime(user.uuid ?? ''),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Text('Loading...');
                                  } else {
                                    if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else {
                                      return Text('Last Seen: ${snapshot.data ?? 'Unknown'}');
                                    }
                                  }
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : CircularProgressIndicator(),
            ),
          ),
        ),
      ],
    );
  }
}
