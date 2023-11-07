import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderld;
  final String senderEmail;
  final String receiverId;
  final String message;
  final Timestamp timestamp;
  final String date;
  final String imgUrl;
  Message(
      {required this.receiverId,
      required this.message,
      required this.senderEmail,
      required this.senderld,
      required this.timestamp,
      required this.date,
      required this.imgUrl});

  Map<String, dynamic> toMAP() {
    return {
      "senderId": senderld,
      "email": senderEmail,
      "receiverId": receiverId,
      "message": message,
      "timeStamp": timestamp,
      "date": date,
      'imgUrl': imgUrl
    };
  }
}
