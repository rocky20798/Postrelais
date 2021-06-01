import 'package:flutter/material.dart';

class Chat extends StatefulWidget{
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat"),
        backgroundColor: Color(0xff262f38),
      ),
      body: new Scaffold(
        backgroundColor: Colors.yellow,
      ),
    );
  }
}