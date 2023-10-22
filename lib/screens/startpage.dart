import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_project/provider/news_provider.dart';
// import 'package:news_project/screens/homepage.dart';
import 'package:news_project/utils/navbar.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;
    return Scaffold(
      body: StreamBuilder(
          stream: Connectivity().onConnectivityChanged,
          builder: (context, AsyncSnapshot<ConnectivityResult> snapshot) {
            if (snapshot.hasData) {
              ConnectivityResult? _result = snapshot.data;
              if (_result == ConnectivityResult.mobile ||
                  _result == ConnectivityResult.wifi) {
                return Container(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 10,
                            child: Container(
                                child: Image.asset('assets/startcard.jpg')),
                          ),
                        ),
                        Column(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                'News From Around the World\nJust for You',
                                style: GoogleFonts.poppins(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Divider(
                              color: Colors.black,
                              indent: w * 0.2,
                              endIndent: w * 0.2,
                            ),
                            Container(
                              padding:
                                  EdgeInsets.symmetric(horizontal: w * 0.11),
                              alignment: Alignment.center,
                              child: Text(
                                'Best to Read ,take your time to read little more about the world ',
                                style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Divider(
                              color: Colors.black,
                              indent: w * 0.2,
                              endIndent: w * 0.2,
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 20),
                          child: ElevatedButton(
                              onPressed: () {
                                Provider.of<NewsProvider>(context,
                                        listen: false)
                                    .get_news('india');
                                Get.off(RootPage());
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange),
                              child: Text(
                                "Get Started",
                                style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    fontWeight: FontWeight.bold),
                              )),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Center(
                  child: Column(
                    children: [
                      Text('INternet Not available '),
                      ElevatedButton(
                          onPressed: () async {
                            ConnectivityResult result =
                                await Connectivity().checkConnectivity();
                            print(result.toString());
                          },
                          child: Text('ReFresh'))
                    ],
                  ),
                );
              }
            } else {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.orange,
                ),
              );
            }
          }),
    );
  }
}
