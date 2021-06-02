import 'package:flutter_lann/messaging/models/convo.dart';
import 'package:flutter_lann/messaging/models/user.dart';
import 'package:flutter_lann/messaging/providers/newMessageProvider.dart';
import 'package:flutter_lann/messaging/widgets/convoWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lann/messaging/services/authentication.dart';
import 'package:provider/provider.dart';

class HomeBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User firebaseUser = Provider.of<User>(context);
    final List<Convo> _convos = Provider.of<List<Convo>>(context);
    final List<UserMessage> _users = Provider.of<List<UserMessage>>(context);
    return Scaffold(
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          IconButton(
              onPressed: Authentication.handleLogout,
              icon: Icon(Icons.first_page, size: 30)),
          Text(firebaseUser.displayName, style: TextStyle(fontSize: 18)),
          IconButton(
              onPressed: () => createNewConvo(context),
              icon: Icon(Icons.add, size: 30))
        ],
      )),
      body: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: getWidgets(context, firebaseUser, _convos, _users))
    );
  }

  void createNewConvo(BuildContext context) {
    Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => NewMessageProvider()));
  }

  Map<String, UserMessage> getUserMap(List<UserMessage> users) {
    final Map<String, UserMessage> userMap = Map();
    for (UserMessage u in users) {
      userMap[u.id] = u;
    }
    return userMap;
  }

  List<Widget> getWidgets(
      BuildContext context, User user, List<Convo> _convos, List<UserMessage> _users) {
    final List<Widget> list = <Widget>[];
    if (_convos != null && _users != null && user != null) {
      final Map<String, UserMessage> userMap = getUserMap(_users);
      for (Convo c in _convos) {
        if (c.userIds[0] == user.uid) {
          list.add(ConvoListItem(
              user: user,
              peer: userMap[c.userIds[1]],
              lastMessage: c.lastMessage));
        } else {
          list.add(ConvoListItem(
              user: user,
              peer: userMap[c.userIds[0]],
              lastMessage: c.lastMessage));
        }
      }
    }

    return list;
  }
}