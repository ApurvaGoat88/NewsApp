import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:news_project/screens/LoginPage.dart';
import 'package:news_project/screens/homepage.dart';
import 'package:news_project/utils/navbar.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _obs = true;
  bool _obs2 = true;
  final _email = TextEditingController();
  final black = Colors.black;
  final orange = const Color(0xFFFA800F);
  final _cpass = TextEditingController();
  final _name = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  Future<void> _handleGoogleSignIn() async {
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
      }
    } catch (error) {
      print('Google Sign-In Error: $error');
    }
  }

  // final _email = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _pass = TextEditingController();
  Future<void> _registerWithEmailAndPassword() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: _email.text,
          password: _pass.text,
        );
        User? user = userCredential.user;
        print(user!.toString());
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
                      Positioned(
                        child: Container(
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
                      ),
                      TextFormField(
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Enter a Valid UserName')));
                              return 'username error';
                            } else {
                              return null;
                            }
                          },
                          controller: _name,
                          onSaved: (text) {},
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            suffixIcon: const Icon(
                              Icons.person,
                              color: Colors.black,
                            ),
                            hintText: 'Username',
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
                                !text.contains('@')) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Enter a Valid Email')));
                              return 'Email error';
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
                              return 'Password';
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
                              return 'Password';
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
                          await _registerWithEmailAndPassword();
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
                            await _handleGoogleSignIn();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RootPage()));
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
                                  style: GoogleFonts.ubuntu(
                                      color: Colors.orange,
                                      fontSize: h * 0.015),
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
                                Navigator.push(
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
