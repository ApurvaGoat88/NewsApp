import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
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

  void showAlertBox() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'LOGOUT',
            style:
                GoogleFonts.ubuntu(fontSize: 25, fontWeight: FontWeight.w500),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                child: Text(
                  "No",
                  style: GoogleFonts.ubuntu(color: Colors.blue),
                ),
                onTap: () => Navigator.pop(context),
              ),
              GestureDetector(
                child: Text(
                  "Yes",
                  style: GoogleFonts.ubuntu(color: Colors.blue),
                ),
                onTap: () async {
                  await signOut().whenComplete(() {
                    Navigator.pop(context);

                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => StartPage()));
                  });
                },
              ),
            ],
          ),
        );
      },
    );
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
      biocontroller.clear();
      await documentRef.update({
        'bio': bio,
      }).whenComplete(() => Navigator.pop(context));
      print('Document successfully updated');
    } catch (e) {
      print('Error updating document: $e');
    }
  }

  void updateUrl(String url) async {
    final currentUser22 = FirebaseAuth.instance.currentUser;

    final DocumentReference documentRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser22!.email!.split('@')[0].toString());
    showDialog(
        context: context,
        builder: (context) {
          return SpinKitWanderingCubes(
            color: Colors.black,
            size: 50,
          );
        });

    // Update specific fields in the document
    try {
      biocontroller.clear();
      await documentRef.update({
        'imgUrl': url,
      }).whenComplete(() => Navigator.pop(context));
      print('Document successfully updated');
    } catch (e) {
      print('Error updating document: $e');
    }
  }

  Future<String> uploadFile(File file, String name, context) async {
    final h = MediaQuery.sizeOf(context).height;
    final w = MediaQuery.sizeOf(context).width;
    print('upload file called');
    String url = '';

    bool isload = true;
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: SpinKitWanderingCubes(
              color: Colors.orange,
              size: 50,
            ),
          );
        });
    String filename = name;
    final firebaseStorageRef =
        FirebaseStorage.instance.ref().child('uploads/$filename');
    final upload = firebaseStorageRef.putFile(file);
    final task = await upload.whenComplete(() => Navigator.pop(context));
    task.ref.getDownloadURL().then((value) {
      cur_url = value;
      url = value.toString();
      updateUrl(value);
      setState(() {});

      Navigator.pop(context);
      print(value);

      // imgUrl = '';
    });
    return url;
  }

  void imagePick() async {
    XFile? image;
    var link = '';
    await ImagePicker()
        .pickImage(
            source: ImageSource.gallery,
            maxHeight: 512,
            maxWidth: 512,
            imageQuality: 75)
        .then((value) {
      if (value != null) {
        setState(() {
          uploadFile(File(value.path), value.name, context);
        });
      } else {}
    });
  }

  String cur_url = '';
  final biocontroller = TextEditingController();
  void showUpdateProfile() {
    showAdaptiveDialog(
        context: context,
        builder: (context) {
          return SafeArea(
            child: Scaffold(
              backgroundColor: Colors.orange.shade50,
              appBar: AppBar(
                title: Text(
                  'EDIT PROFILE',
                  style: GoogleFonts.ubuntu(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                centerTitle: true,
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      biocontroller.clear();
                    },
                    icon: Icon(
                      Icons.close,
                      color: Colors.red,
                    )),
                actions: [
                  IconButton(
                    onPressed: () async {
                      if (biocontroller.text.isNotEmpty) {
                        update(biocontroller.text);
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    icon: Icon(Icons.check),
                    color: Colors.green,
                  )
                ],
              ),
              body: Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      height: 35,
                    ),
                    CircleAvatar(
                      backgroundImage:
                          NetworkImage(cur_url == '' ? user.imgUrl : cur_url),
                      radius: 100,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        imagePick();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.orange.shade200,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'Change Photo',
                            style: GoogleFonts.ubuntu(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                        child: Container(
                      margin: EdgeInsets.only(top: 5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 3),
                                blurRadius: 2,
                                spreadRadius: 3)
                          ]),
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ListTile(
                              title: Text(
                                'Bio',
                                style: GoogleFonts.ubuntu(
                                    fontSize: 17, fontWeight: FontWeight.w700),
                              ),
                              contentPadding: EdgeInsets.all(30),
                              subtitle: TextField(
                                controller: biocontroller,
                                maxLines: 10,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(),
                                  hintText: user.bio,
                                  hintStyle: TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                              onTap: () => _auth
                                  .sendPasswordResetEmail(email: user.email)
                                  .whenComplete(() =>
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text('Mail sent to ' +
                                                  "${user.email}")))),
                              child: Text(
                                'Get Password Reset link',
                                style: GoogleFonts.ubuntu(
                                    fontSize: 15, color: Colors.grey),
                              ),
                            )
                          ],
                        ),
                      ),
                    )),
                  ],
                ),
              ),
            ),
          );
        });
  }

  UserModel user =
      UserModel(bio: '', email: '', username: '', uid: '', imgUrl: '');

  final currentUser = FirebaseAuth.instance.currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final usercollection = FirebaseFirestore.instance.collection('Users');
  // List drop = ['Logout'];
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
          actions: [
            PopupMenuButton<String>(
              onSelected: (value) {
                print(value);
                if (value == 'logout') {
                  showAlertBox();
                }
                if (value == 'update') {
                  showUpdateProfile();
                }
              },
              itemBuilder: (context) {
                return [
                  PopupMenuItem<String>(
                    value: 'update',
                    child: Text('Update Profile'),
                  ),
                  PopupMenuItem<String>(
                    value: 'logout',
                    child: Text('Logout'),
                  ),
                ];
              },
              icon: Icon(Icons.menu),
            )
          ],

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
              user = UserModel.fromJson(
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
                            SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            // icon: Icon(Icons.edit)),
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
