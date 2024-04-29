import 'package:chat_application_iub_cse464/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserManage{
  final firebase = FirebaseFirestore.instance;


  Future<void> createUserProfile({required String userName, required String userEmail, required String userID})async{

    var user = UserData(
      name: userName,
      uuid: userID,
      email: userEmail,
    );


    await firebase.collection("users").doc(userID).set(user.toMap());

    // await firebase.collection("users").add({
    //   "name": userName,
    //   "email": userEmail,
    //   "my_chats": FieldValue.arrayUnion([]),
    // });
  }

Future<List<UserData>> getUsers() async {
    List<UserData> users = [];

    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        users.add(UserData.fromMap(data));
      }
    } catch (e) {}

    return users;
  }


}