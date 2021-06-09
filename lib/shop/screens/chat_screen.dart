import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lann/shop/providers/auth.dart';
import 'package:flutter_lann/shop/providers/message.dart';
import 'package:flutter_lann/shop/providers/messages.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatelessWidget {
  static const routeName = '/chat';
  ScrollController _scrollController = ScrollController();

  _scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<Auth>(context, listen: false);
    final _messages = Provider.of<Messages>(context);
    final _inputController = TextEditingController();
    String daySave = null;

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    bool personAbfrage(int index) {
      if (_auth.isAdmin) {
        return _messages.items[index].reciID == "Admin";
      } else {
        return _messages.items[index].reciID == _auth.userId;
      }
    }

    Widget dayWidget(int index) {
      daySave = DateFormat('dd-MM-yyyy')
          .format(DateTime.parse(_messages.items[index].timestamp));
      print(daySave);
      return Bubble(
          margin: BubbleEdges.only(top: 10),
          alignment: Alignment.center,
          color: Color.fromRGBO(212, 234, 244, 1.0),
          child: Text(daySave));
    }

    return Scaffold(
      body: Stack(
        children: <Widget>[
          ListView.builder(
            controller: _scrollController,
            itemCount: _messages.items.length,
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 10, bottom: 65),
            physics: AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Column(
                children: [
                  if (daySave !=
                      DateFormat('dd-MM-yyyy').format(
                          DateTime.parse(_messages.items[index].timestamp)))
                    dayWidget(index),
                  Bubble(
                    margin: BubbleEdges.only(top: 10, left: 10, right: 10),
                    alignment: personAbfrage(index)
                        ? Alignment.topLeft
                        : Alignment.topRight,
                    nip: personAbfrage(index)
                        ? BubbleNip.leftBottom
                        : BubbleNip.rightBottom,
                    color: personAbfrage(index)
                        ? Color.fromRGBO(212, 234, 244, 1.0)
                        : Color.fromRGBO(225, 255, 199, 1.0),
                    child: Text(_messages.items[index].content,
                        style: TextStyle(fontSize: 25),
                        textAlign: personAbfrage(index)
                            ? TextAlign.left
                            : TextAlign.right),
                  ),
                ],
              );
            },
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.blueGrey,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _inputController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 20,
                      decoration: InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      _messages.addMessage(Message(
                          content: _inputController.text,
                          sendID: _auth.isAdmin ? "Admin" : _auth.userId,
                          reciID: _auth.isAdmin ? _messages.userId : "Admin",
                          timestamp: DateTime.now().toIso8601String(),
                          isRead: false));
                    },
                    child: Icon(
                      Icons.send,
                      color: Color(0xffc9a42c),
                      size: 18,
                    ),
                    backgroundColor: Color(0xff262f38),
                    elevation: 0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
