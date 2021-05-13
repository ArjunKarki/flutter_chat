import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_chat/widgets/chats/MessageInput.dart';
import 'package:flutter_chat/widgets/chats/Messages.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String newMessage = "";
  final _messageController = TextEditingController();
  var userData;
  var user;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      Firebase.initializeApp();
      user = FirebaseAuth.instance.currentUser;
      userData = await FirebaseFirestore.instance
          .collection("user")
          .doc(user.uid)
          .get();
    });
  }

  void onsendMessage(newMessage) async {
    // final userData =
    //     await FirebaseFirestore.instance.collection("user").doc(user.uid).get();
    FirebaseFirestore.instance.collection("chat").add({
      "message": newMessage,
      "createdAt": Timestamp.now(),
      "userId": user.uid,
      "userName": userData.data()["name"]
    });
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Screen"),
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              if (value == "logout") {
                FirebaseAuth.instance.signOut();
              }
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Logout"),
                    Icon(
                      Icons.logout,
                      color: Colors.pink,
                    )
                  ],
                ),
                value: "logout",
              )
            ],
          )
        ],
      ),
      body: Column(
        children: [
          Messages(user: user),
          MessageInput(sendMessage: onsendMessage)
        ],
      ),
    );
  }
}
