import 'package:flutter/material.dart';
import 'package:flutter_lann/shop/providers/auth.dart';
import 'package:flutter_lann/shop/providers/messages.dart';
import 'package:flutter_lann/shop/screens/home_screen.dart';
import 'package:provider/provider.dart';

class ChatScreenOverview extends StatelessWidget {
  static const routeName = '/chatOverview';
  ScrollController _scrollController = ScrollController();

  _scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<Auth>(context, listen: false);
    final _messages = Provider.of<Messages>(context);
    final _inputController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    return Scaffold(
      body: ListView.builder(
        controller: _scrollController,
        itemCount: _messages.users.length,
        shrinkWrap: true,
        padding: EdgeInsets.only(top: 10, bottom: 5),
        physics: AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                decoration: BoxDecoration(
                  color: (true ? Colors.grey.shade200 : Colors.blue[200]),
                ),
                padding: EdgeInsets.all(16),
                child: TextButton( 
                    onPressed: () {
                      _messages.userId = _messages.users[index];
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => HomeScreen(3, null, 2)));
                    },
                    child: Text(
                      _messages.users[index].substring(0,5),
                      style: TextStyle(fontSize: 15),
                    )),
              ),
            ),
          );
        },
      ),
    );
  }
}
