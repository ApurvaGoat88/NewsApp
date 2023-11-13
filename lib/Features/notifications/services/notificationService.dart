import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseNotifications {
  Future<void> initNotification() async {
    final _noti = FirebaseMessaging.instance;
    await _noti.requestPermission();
    final token = await _noti.getToken();
    print('token is ' + token.toString());
  }

  final _mess = FirebaseMessaging.instance;
  
}
