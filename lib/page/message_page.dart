import 'package:flutter/material.dart';

class MessagePage extends StatefulWidget {
  final String id;
  const MessagePage({super.key, required this.id});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Center(child: Text("Message page" + widget.id)),
      ),
    );
  }
}
