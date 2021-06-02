import 'package:flutter/material.dart';
import 'package:flutter_lann/shop/providers/message.dart';

class Messages with ChangeNotifier {
  List<ChatMessage> chatVerlauf = [];

  void addMessage(String text, String type, String id) {
    chatVerlauf.add(ChatMessage(text, type, id, DateTime.now().toIso8601String()));
  }

  List getMessages(){
    return chatVerlauf;
  }
  const db = firebase.firestore()

  fetchGroupByUserID(uid) {
  const vm = this;
  return new Promise((resolve, reject) => {
    const groupRef = db.collection('group')
    groupRef
     .where('members', 'array-contains', uid)
     .onSnapshot((querySnapshot) => {
       const allGroups = []
       querySnapshot.forEach((doc) => {
         const data = doc.data()
         data.id = doc.id
         if (data.recentMessage) allGroups.push(data)
       })
       vm.groups = allGroups
     })
   })
},
}
