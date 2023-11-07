import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:news_project/Features/LoginPage/Screens/LoginPage.dart';
import 'package:news_project/Features/HomePage/Screens/homepage.dart';
import 'package:news_project/Features/HomePage/Screens/navbar.dart';
import 'package:news_project/model/UserModel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String imgUrl = '';
  bool _obs = true;
  bool _obs2 = true;
  final _email = TextEditingController();
  final black = Colors.black;
  final orange = const Color(0xFFFA800F);
  final _cpass = TextEditingController();
  final _name = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  Future<User?> _handleGoogleSignIn(UserModel usermodel) async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        // Sign in to Firebase with the Google credentials
        final UserCredential authResult =
            await FirebaseAuth.instance.signInWithCredential(credential);
        final User? user = authResult.user;
        print('User signed in with Google: ${user!.displayName}');
        try {
          await FirebaseFirestore.instance
              .collection("Users")
              .doc(user.email!.split('@')[0].toString())
              .set({
            "username": user.displayName,
            "uid": user.uid,
            "email": user.email,
            "bio": "",
            'imgUrl': user.photoURL.toString()
          });
        } catch (e) {
          print('$e');
        }
      }
    } catch (e) {
      print(e);
    }
  }

  // final _email = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Future<String> uploadFile(File file, String name) async {
    print('upload file called');
    String url = '';
    String filename = name;
    final firebaseStorageRef =
        FirebaseStorage.instance.ref().child('uploads/$filename');
    final upload = firebaseStorageRef.putFile(file);
    final task = await upload.whenComplete(() => null);
    task.ref.getDownloadURL().then((value) {
      url = value.toString();

      setState(() {
        imgUrl = url;
      });
      print(imgUrl);
    });
    return url;
  }

  Future<File> uploadImage() async {
    XFile? image;

    ImagePicker()
        .pickImage(
            source: ImageSource.gallery,
            maxHeight: 512,
            maxWidth: 512,
            imageQuality: 75)
        .then((value) {
      setState(() {
        uploadFile(File(value!.path), value.name);
        print('image pciked');
      });
    });
    return File(image!.path);
  }

  final _pass = TextEditingController();
  Future<User?> _registerWithEmailAndPassword(UserModel useree) async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: _email.text,
          password: _pass.text,
        );
        final result = _auth.currentUser;
        useree.uid = result!.uid;
        try {
          await FirebaseFirestore.instance
              .collection("Users")
              .doc(userCredential.user!.email!.split('@')[0].toString())
              .set(useree.toJson());
        } catch (e) {
          print('$e');
        }

        User? user = userCredential.user;

        print(user!.toString());
        return user;
        // User account created successfully.
      } on FirebaseAuthException catch (e) {
        print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: const Color(0xFFFA800F),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          height: h,
          width: w,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    'assets/Android Large - 1 (1).png',
                  ),
                  fit: BoxFit.cover)),
          child: Container(
            child: Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.all(w * 0.05),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: h * 0.02),
                        child: Container(
                          child: Text(
                            'Create New Account',
                            style: GoogleFonts.openSans(
                                fontSize: h * 0.04,
                                fontWeight: FontWeight.bold,
                                color: orange),
                          ),
                        ),
                      ),
                      Card(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                await uploadImage();
                              },
                              child: CircleAvatar(
                                  backgroundColor: Colors.grey.shade200,
                                  radius: 30,
                                  child: Icon(
                                    Icons.add_a_photo_outlined,
                                    color: Colors.black,
                                    size: 20,
                                  )),
                            ),
                            SizedBox(
                              width: w * 0.1,
                            ),
                            Container(
                              child: Text('Upload a Profile picture'),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: h * 0.02,
                      ),
                      TextFormField(
                          validator: (text) {
                            if (text == null ||
                                text.isEmpty ||
                                !text.contains('@')) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Enter a Valid Email')));
                              return '';
                            } else {
                              return null;
                            }
                          },
                          controller: _email,
                          onSaved: (text) {},
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            suffixIcon: const Icon(
                              Icons.email_outlined,
                              color: Colors.black,
                            ),
                            hintText: 'Email',
                            hintStyle: GoogleFonts.ubuntu(color: black),
                            labelStyle: GoogleFonts.ubuntu(
                              color: black,
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: black)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: black)),
                          ),
                          maxLines: 1),
                      SizedBox(
                        height: h * 0.02,
                      ),
                      TextFormField(
                          validator: (text) {
                            if (text == null ||
                                text.isEmpty ||
                                text.length <= 6) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Password must be more than 6 letters')));
                              return '';
                            } else {
                              return null;
                            }
                          },
                          controller: _pass,
                          obscureText: _obs,
                          onSaved: (text) {},
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obs = !_obs;
                                });
                              },
                              icon: Icon(_obs
                                  ? Icons.remove_red_eye_outlined
                                  : Icons.remove_red_eye),
                              color: Colors.black,
                            ),
                            hintText: 'Create Password',
                            hintStyle: GoogleFonts.ubuntu(color: black),
                            labelStyle: GoogleFonts.ubuntu(
                              color: black,
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: black)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: black)),
                          ),
                          maxLines: 1),
                      SizedBox(
                        height: h * 0.02,
                      ),
                      TextFormField(
                          validator: (text) {
                            if (text == null ||
                                text.isEmpty ||
                                text.length <= 6) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Password must be more than 6 letters')));
                              return '';
                            } else {
                              return null;
                            }
                          },
                          controller: _cpass,
                          obscureText: _obs2,
                          onSaved: (text) {},
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obs2 = !_obs2;
                                });
                              },
                              icon: Icon(_obs2
                                  ? Icons.remove_red_eye_outlined
                                  : Icons.remove_red_eye),
                              color: Colors.black,
                            ),
                            hintText: 'Confirm Password',
                            hintStyle: GoogleFonts.ubuntu(color: black),
                            labelStyle: GoogleFonts.ubuntu(
                              color: black,
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: black)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: black)),
                          ),
                          maxLines: 1),
                      SizedBox(
                        height: h * 0.02,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (imgUrl.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Waiting for image to upload")));
                          } else {
                            if (_cpass.text == _pass.text) {
                              var user = await _registerWithEmailAndPassword(
                                  UserModel(
                                      bio: 'null',
                                      email: _email.text,
                                      uid: '',
                                      username: _name.text,
                                      imgUrl: imgUrl));
                              if (user != null) {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RootPage()));
                              } else {}
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Passwords is not Same')));
                            }
                          }
                        },
                        child: const Text('SIGN UP'),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: orange,
                            elevation: 10,
                            minimumSize: Size(w * 0.4, h * 0.05),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24))),
                      ),
                      SizedBox(
                        height: h * 0.02,
                      ),
                      Row(children: <Widget>[
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "or",
                            style: GoogleFonts.ubuntu(color: Colors.grey),
                          ),
                        ),
                        const Expanded(child: Divider()),
                      ]),
                      SizedBox(
                        height: h * 0.02,
                      ),
                      InkWell(
                          onTap: () async {
                            await _handleGoogleSignIn(UserModel(
                              bio: '',
                              email: '',
                              uid: '',
                              username: _name.text,
                              imgUrl: '',
                            )).then((value) => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RootPage())));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  const BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0.0, 0.50), //(x,y)
                                    blurRadius: 6.0,
                                  ),
                                ],
                                border:
                                    Border.all(color: Colors.grey.shade200)),
                            width: w * 0.9,
                            height: h * 0.07,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'Continue with Google',
                                  style:
                                      GoogleFonts.ubuntu(fontSize: h * 0.015),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset('assets/pngegg.png'),
                                ),
                              ],
                            ),
                          )),
                      SizedBox(
                        height: h * 0.02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account?',
                            style: GoogleFonts.ubuntu(),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginPage()));
                              },
                              child: Text(
                                'Login here',
                                style: GoogleFonts.ubuntu(
                                    decoration: TextDecoration.underline),
                              ))
                        ],
                      )
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
