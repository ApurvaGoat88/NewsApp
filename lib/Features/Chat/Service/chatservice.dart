import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news_project/model/MessageModel.dart';

class ChatService extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _store = FirebaseFirestore.instance;
  String current = '';

  void sendMessage(String Remail, String message) async {
    final currentuserId = _auth.currentUser!.uid;
    final now = DateTime.now();
    final currentUserEmail = _auth.currentUser!.email.toString();
    final time = Timestamp.now();
    final now11 = DateFormat("dd-MM-yyyy h-mma").format(now);
    print(now11);
    Message newMessage = Message(
        receiverId: Remail,
        message: message,
        senderEmail: currentUserEmail,
        senderld: currentuserId,
        timestamp: time,
        date: now11.toString());

    List<String> ids = [currentuserId, Remail];
    ids.sort();
    String room = ids.join("-");
    await _store
        .collection('ChatRoom')
        .doc(room)
        .collection('Messages')
        .add(newMessage.toMAP());
  }

  Stream<QuerySnapshot> getMessages(String uid2, String uid1) {
    print(uid1 + "           " + uid2);
    List<String> ids = [uid1, uid2];
    ids.sort();
    String room = ids.join("-");
    return _store
        .collection('ChatRoom')
        .doc(room)
        .collection('Messages')
        .orderBy('timeStamp', descending: true)
        // .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
