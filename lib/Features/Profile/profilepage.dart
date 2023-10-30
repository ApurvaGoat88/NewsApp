import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_project/Features/LoginPage/Screens/startpage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
                GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          centerTitle: true,
          // elevation:0,
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Users")
              .doc(currentUser!.email)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final userdata = snapshot.data!.data() as Map<String, dynamic>;
              return Container(
                height: h,
                width: w,
                color: Colors.grey.shade100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: h * 0.03),
                      child: CircleAvatar(
                        radius: h * .09,
                        backgroundImage:
                            NetworkImage(currentUser!.photoURL.toString()),
                        backgroundColor: Colors.white,
                        // child: Icon(Icons.person),
                      ),
                    ),
                    SizedBox(
                      height: h * 0.02,
                    ),
                    Column(
                      children: [
                        Text(
                          currentUser!.displayName.toString(),
                          style: GoogleFonts.ubuntu(
                              fontWeight: FontWeight.bold, fontSize: h * 0.036),
                        ),
                        SizedBox(
                          height: h * 0.01,
                        ),
                        Text(
                          currentUser!.email.toString(),
                          style:
                              GoogleFonts.ubuntu(color: Colors.grey.shade700),
                        ),
                        SizedBox(
                          height: h * 0.01,
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: h * 0.04),
                          width: w * 0.85,
                          child: Expanded(
                            child: Text(
                              'Flutter Developer  |  Football  | Student at Ajay Kumar garg Engineering College | Prayagraj </>',
                              style: GoogleFonts.ubuntu(color: Colors.grey),
                              maxLines: null,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: h * 0.02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Card(
                              elevation: 0,
                              color: Colors.grey.shade100,
                              child: Container(
                                height: h * 0.12,
                                width: w * 0.3,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '7',
                                      style: GoogleFonts.ubuntu(
                                          fontSize: h * 0.04,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange),
                                    ),
                                    Text('Reading Hours',
                                        style: GoogleFonts.ubuntu()),
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              elevation: 0,
                              color: Colors.grey.shade100,
                              child: Container(
                                height: h * 0.12,
                                width: w * 0.3,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '200K',
                                      style: GoogleFonts.ubuntu(
                                          color: Colors.orange,
                                          fontWeight: FontWeight.bold,
                                          fontSize: h * 0.04),
                                    ),
                                    Text('Followers',
                                        style: GoogleFonts.ubuntu()),
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              elevation: 0,
                              color: Colors.grey.shade100,
                              child: Container(
                                height: h * 0.12,
                                width: w * 0.3,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '100',
                                      style: GoogleFonts.ubuntu(
                                          fontSize: h * 0.04,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange),
                                    ),
                                    Text('Followings',
                                        style: GoogleFonts.ubuntu()),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: h * 0.1,
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text('Edit Profile'),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              elevation: 4,
                              minimumSize: Size(w * 0.84, h * 0.05),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24))),
                        ),
                        SizedBox(
                          height: h * 0.02,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await _auth.signOut().whenComplete(() =>
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => StartPage())));
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
              );
            } else {
              return SpinKitFoldingCube();
            }
          },
        ));
  }
}
