import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:news_project/Features/LoginPage/Screens/startpage.dart';
import 'package:news_project/model/UserModel.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key, required this.userModel});
  final UserModel userModel;

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final _bio = TextEditingController();
  void showupdateopt() {
    Get.defaultDialog(
        title: "Update User Info",
        content: Container(
          child: Column(children: [
            TextField(
              maxLines: 5,
              controller: _bio,
              decoration: InputDecoration(
                  labelText: "Update Bio",
                  labelStyle:
                      GoogleFonts.ubuntu(color: Colors.black, fontSize: 20),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(),
                  disabledBorder: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder()),
            ),
            SizedBox(
              height: 10,
            ),
            // TextField(
            //     controller: email,
            //     decoration: InputDecoration(labelText: "Email")),
            SizedBox(
              height: 20,
            ),
            Container(
              width: 100,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(23))),
                  onPressed: () {
                    update(_bio.text.toString());
                  },
                  child: Text("Save")),
            )
          ]),
        ));
  }

  Future signOut() async {
    await GoogleSignIn().disconnect();
    await FirebaseAuth.instance.signOut();
  }

  void update(String bio) async {
    final currentUser22 = FirebaseAuth.instance.currentUser;

    final DocumentReference documentRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser22!.email!.split('@')[0].toString());

    // Update specific fields in the document
    try {
      await documentRef.update({
        'bio': bio,
      });
      print('Document successfully updated');
    } catch (e) {
      print('Error updating document: $e');
    }
  }

  final currentUser = FirebaseAuth.instance.currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final usercollection = FirebaseFirestore.instance.collection('Users');
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;
    final usermodel = widget.userModel;
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          backgroundColor: Colors.grey.shade100,
          foregroundColor: Colors.black,
          title: Text(
            'PROFILE',
            style:
                GoogleFonts.ubuntu(fontWeight: FontWeight.bold, fontSize: 25),
          ),

          centerTitle: true,
          // elevation:0,
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: h * 0.8,
            width: w,
            color: Colors.grey.shade100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  margin: EdgeInsets.only(top: h * 0.03),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Container(
                                child: Center(
                                  child: CircleAvatar(
                                    radius: h * 0.2,
                                    backgroundImage: NetworkImage(
                                        usermodel.imgUrl.toString()),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: CircleAvatar(
                          radius: h * .09,
                          backgroundImage:
                              NetworkImage(usermodel.imgUrl.toString()),
                          backgroundColor: Colors.white,
                          // child: Icon(Icons.person),
                        ),
                      ),
                      SizedBox(
                        height: h * 0.02,
                      ),
                      Text(
                        usermodel.email.split('@')[0].toString(),
                        style: GoogleFonts.ubuntu(
                            fontWeight: FontWeight.bold, fontSize: h * 0.036),
                      ),
                      SizedBox(
                        height: h * 0.01,
                      ),
                      Text(
                        usermodel.email,
                        style: GoogleFonts.ubuntu(color: Colors.grey.shade700),
                      ),
                      SizedBox(
                        height: h * 0.01,
                      ),
                      SizedBox(
                        height: h * 0.01,
                      ),
                      SizedBox(
                        height: h * 0.01,
                      ),
                      SizedBox(
                        height: h * 0.01,
                      ),
                      Column(children: [
                        Text(
                          'Bio',
                          style: GoogleFonts.ubuntu(
                              fontSize: 20, color: Colors.grey.shade600),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(10)),
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: h * 0.04),
                          width: w * 0.85,
                          height: h * 0.2,
                          child: Expanded(
                            child: Text(
                              usermodel.bio,
                              style: GoogleFonts.ubuntu(color: Colors.grey),
                              maxLines: null,
                            ),
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
                SizedBox(
                  height: h * 0.02,
                ),
                SizedBox(
                  height: h * 0.02,
                ),
              ],
            ),
          ),
        ));
  }
}
