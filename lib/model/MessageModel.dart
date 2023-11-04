import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderld;
  final String senderEmail;
  final String receiverId;
  final String message;
  final Timestamp timestamp;
  Message(
      {required this.receiverId,
      required this.message,
      required this.senderEmail,
      required this.senderld,
      required this.timestamp});

  Map<String, dynamic> toMAP() {
    return {
      "senderId": senderld,
      "email": senderEmail,
      "receiverId": receiverId,
      "message": message,
      "timeStamp": timestamp
    };
  }
}
