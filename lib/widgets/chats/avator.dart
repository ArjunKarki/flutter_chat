import 'package:flutter/material.dart';

class Avator extends StatelessWidget {
  final String proPicUrl;
  Avator({this.proPicUrl});
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.white,
      backgroundImage: NetworkImage(
        proPicUrl ?? "https://i.dlpng.com/static/png/6837968_preview.png",
      ),
    );
  }
}
