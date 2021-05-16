import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/widgets/chats/avator.dart';

class Messages extends StatelessWidget {
  const Messages({
    @required this.user,
  });

  final user;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("chat")
          .orderBy("createdAt", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Expanded(
            child: Center(
              child: Text("loading...."),
            ),
          );
        }
        return Expanded(
          child: ListView.builder(
            reverse: true,
            itemCount: snapshot.data.docs.length,
            itemBuilder: (ctx, index) {
              final _message = snapshot.data.docs[index].data();
              final isMe = user.uid == _message["userId"];
              return Container(
                margin: EdgeInsets.only(
                    left: isMe ? 25 : 6, right: isMe ? 6 : 25, top: 10),
                child: Row(
                  mainAxisAlignment:
                      isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isMe)
                      Avator(
                        proPicUrl: _message["proPic"],
                      ),
                    Container(
                      margin: EdgeInsets.only(
                        left: isMe ? 0 : 5,
                        right: isMe ? 5 : 0,
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: isMe ? Colors.grey[400] : Colors.purple,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: isMe ? Radius.circular(10) : Radius.zero,
                          bottomRight: isMe ? Radius.zero : Radius.circular(10),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: isMe
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Text(
                            _message["userName"],
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isMe ? Colors.black87 : Colors.white),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            _message["message"],
                            style: TextStyle(
                                color: isMe ? Colors.black87 : Colors.white),
                          ),
                        ],
                      ),
                    ),
                    if (isMe)
                      Avator(
                        proPicUrl: _message["proPic"],
                      ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
