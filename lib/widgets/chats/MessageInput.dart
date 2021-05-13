import 'package:flutter/material.dart';

class MessageInput extends StatefulWidget {
  const MessageInput({this.sendMessage});

  final Function sendMessage;

  @override
  _MessageInputState createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  String _newMessage = "";
  final _messageController = TextEditingController();

  void sendMessage() {
    widget.sendMessage(_newMessage);
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(hintText: "Enter message...."),
              onChanged: (value) {
                setState(() {
                  _newMessage = value;
                });
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _newMessage.trim().length > 0 ? sendMessage : null,
          )
        ],
      ),
    );
  }
}
