import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:news_project/Features/LoginPage/Screens/startpage.dart';
import 'package:news_project/model/UserModel.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().disconnect();

    // : await FirebaseAuth.instance.signOut();
    print('sign out');
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
    return Scaffold(
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
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Users")
              .doc(currentUser!.email!.split('@')[0])
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final userdata = UserModel.fromJson(
                  snapshot.data!.data() as Map<String, dynamic>);
              return SingleChildScrollView(
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
                                              userdata.imgUrl.toString()),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: CircleAvatar(
                                radius: h * .09,
                                backgroundImage:
                                    NetworkImage(userdata.imgUrl.toString()),
                                backgroundColor: Colors.white,
                                // child: Icon(Icons.person),
                              ),
                            ),
                            SizedBox(
                              height: h * 0.02,
                            ),
                            Text(
                              userdata.email.split('@')[0].toString(),
                              style: GoogleFonts.ubuntu(
                                  fontWeight: FontWeight.bold,
                                  fontSize: h * 0.036),
                            ),
                            SizedBox(
                              height: h * 0.01,
                            ),
                            Text(
                              userdata.email,
                              style: GoogleFonts.ubuntu(
                                  color: Colors.grey.shade700),
                            ),
                            SizedBox(
                              height: h * 0.01,
                            ),
                            IconButton(
                                onPressed: () => showupdateopt(),
                                icon: Icon(Icons.edit)),
                            Column(children: [
                              Text(
                                'Bio',
                                style: GoogleFonts.ubuntu(
                                    fontSize: 20, color: Colors.grey.shade600),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade400),
                                    borderRadius: BorderRadius.circular(10)),
                                alignment: Alignment.center,
                                padding:
                                    EdgeInsets.symmetric(horizontal: h * 0.04),
                                width: w * 0.85,
                                height: h * 0.2,
                                child: Expanded(
                                  child: Text(
                                    userdata.bio,
                                    style:
                                        GoogleFonts.ubuntu(color: Colors.grey),
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Sign Out now ? ',
                                      style: GoogleFonts.ubuntu(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    content: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        GestureDetector(
                                          child: Text(
                                            "No",
                                            style: GoogleFonts.ubuntu(
                                                color: Colors.blue),
                                          ),
                                          onTap: () => Navigator.pop(context),
                                        ),
                                        GestureDetector(
                                          child: Text(
                                            "Yes",
                                            style: GoogleFonts.ubuntu(
                                                color: Colors.blue),
                                          ),
                                          onTap: () async {
                                            await signOut().whenComplete(() =>
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            StartPage())));
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            child: const Text('Log out'),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                elevation: 4,
                                minimumSize: Size(w * 0.84, h * 0.05),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24))),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            } else {
              return SpinKitFoldingCube();
            }
          },
        ));
  }
}
