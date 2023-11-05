import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_project/Features/Chat/Service/chatservice.dart';

class Chatscreen extends StatefulWidget {
  const Chatscreen(
      {super.key,
      required this.Remail,
      required this.Rid,
      required this.imgUrl,
      required this.senderUrl});
  final Remail;
  final senderUrl;
  final Rid;
  final imgUrl;
  @override
  State<Chatscreen> createState() => _ChatscreenState();
}

class _ChatscreenState extends State<Chatscreen> {
  Future<String?> getImageUrlForUser() async {
    final em = FirebaseAuth.instance.currentUser!.email.toString();

    final userSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('email', isEqualTo: em)
        .get();

    if (userSnapshot.docs.isNotEmpty) {
      final userData = userSnapshot.docs.first.data() as Map<String, dynamic>;

      final imageUrl = userData['imgUrl'] as String?;
      print(imageUrl);
      return imageUrl;
    } else {
      // Handle the case when the user's document is not found
      return null;
    }
  }

  final _messageController = TextEditingController();
  final chatService = ChatService();
  final auth = FirebaseAuth.instance;
  void send() {
    if (_messageController.text.isNotEmpty) {
      chatService.sendMessage(widget.Rid, _messageController.text.toString());
    }
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.Remail.toString().split('@')[0],
              style:
                  GoogleFonts.ubuntu(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(
            height: 20,
            color: Colors.black,
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: builderMessage(),
          )),
          input(),
        ],
      ),
    );
  }

  Widget builderMessage() {
    return StreamBuilder(
      stream: chatService.getMessages(widget.Rid, auth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SpinKitWanderingCubes(
              color: Colors.orange,
              size: 35,
            ),
          );
        }
        print('tolist');
        return ListView(
            reverse: true,
            physics: BouncingScrollPhysics(),
            children:
                snapshot.data!.docs.map((e) => messages(e, context)).toList());
      },
    );
  }

  Widget messages(DocumentSnapshot docsss, context) {
    final w = MediaQuery.sizeOf(context).width;
    Map<String, dynamic> data = docsss.data() as Map<String, dynamic>;
    print(data['senderId']);
    var align = (data['senderId'] == auth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    // final kk = (data['senderId'] == auth.currentUser!.uid);
    print(data['timeStamp'].toString());
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        alignment: align,
        child: Column(
          children: [
            // Container(
            //   alignment: align,
            //   child: Text(
            //     data['email'].toString(),
            //     style: GoogleFonts.ubuntu(color: Colors.black),
            //   ),
            // ),

            data['senderId'] == auth.currentUser!.uid
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                          alignment: Alignment.center,
                          width: w * 0.7,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(23),
                              color: Colors.orange.shade100),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              data['message'],
                              style: GoogleFonts.ubuntu(fontSize: 20),
                            ),
                          )),
                      CircleAvatar(
                        radius: 12,
                        backgroundImage: NetworkImage(widget.senderUrl),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundImage: NetworkImage(widget.imgUrl),
                      ),
                      Container(
                          alignment: Alignment.center,
                          width: w * 0.7,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(23),
                              color: Colors.orange.shade100),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              data['message'],
                              style: GoogleFonts.ubuntu(fontSize: 20),
                            ),
                          )),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget input() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        controller: _messageController,
        decoration: InputDecoration(
            suffixIconColor: Colors.black,
            hintText: 'Message',
            focusColor: Colors.black,
            hoverColor: Colors.black,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(23)),
            suffixIcon: IconButton(
                onPressed: () => send(), icon: Icon(Icons.send_rounded))),
      ),
    );
  }
}
