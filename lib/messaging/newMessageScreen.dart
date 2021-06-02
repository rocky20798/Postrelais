import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_lann/messaging/models/user.dart';
import 'package:flutter_lann/messaging/widgets/userRow.dart';

class NewMessageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);
    final List<UserMessage> userDirectory = Provider.of<List<UserMessage>>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Select Contact')),
      body: user !=null && userDirectory != null
          ? ListView(
              shrinkWrap: true, children: getListViewItems(userDirectory, user))
          : Container(),
    );
  }

  List<Widget> getListViewItems(List<UserMessage> userDirectory, User user) {
    final List<Widget> list = <Widget>[];
    for (UserMessage contact in userDirectory) {
      if (contact.id != user.uid) {
        list.add(UserRow(uid: user.uid, contact: contact));
        list.add(Divider(thickness: 1.0));
      }
    }
    return list;
  }
}