import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:news_project/Features/LoginPage/Screens/SignUpPage.dart';
import 'package:news_project/Features/HomePage/Screens/homepage.dart';
import 'package:news_project/Features/HomePage/Screens/navbar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obs = true;
  final _email = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final black = Colors.black;
  final orange = Color(0xFFFA800F);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  Future<User?> _handleGoogleSignIn() async {
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
        return user;
      }
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  Future<User?> _signInWithEmailAndPassword() async {
    if (_formKey.currentState!.validate()) {
      try {
        final UserCredential userCredential =
            await _auth.signInWithEmailAndPassword(
          email: _email.text,
          password: _pass.text,
        );
        final User? user = userCredential.user;
        return user;
        print(user!.email.toString());
        // User logged in successfully, you can navigate to another screen.
      } catch (e) {
        print(e.toString());
      }
    }
  }

  // final _email = TextEditingController();
  final _pass = TextEditingController();

  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: Color(0xFFFA800F),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          height: h,
          width: w,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    'assets/Android Large - 1.png',
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
                              'Welcome Back',
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
                            if (text == null ||
                                text.isEmpty ||
                                text.contains('@') == false) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Enter a Valid Email')));
                              return 'Email is Not Valid ';
                            }
                            return null;
                          },
                          controller: _email,
                          onSaved: (text) {},
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            suffixIcon: Icon(
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
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      'Password must be more than 6 letters')));
                              return 'Password Error';
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
                            hintText: 'Password',
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
                      Row(
                        children: [
                          TextButton(
                              onPressed: () {},
                              child: Text(
                                'Forgot Password?',
                                style: GoogleFonts.ubuntu(),
                              ))
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          var user = await _signInWithEmailAndPassword();
                          if (user != null) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RootPage()));
                          }
                        },
                        child: Text('LOGIN'),
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
                        Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "or",
                            style: GoogleFonts.ubuntu(color: Colors.grey),
                          ),
                        ),
                        Expanded(child: Divider()),
                      ]),
                      SizedBox(
                        height: h * 0.02,
                      ),
                      InkWell(
                          onTap: () async {
                            var user = await _handleGoogleSignIn();

                            if (user != null) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RootPage()));
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
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
                            'New User?',
                            style: GoogleFonts.ubuntu(),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignUpPage()));
                              },
                              child: Text(
                                'Create new account',
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
