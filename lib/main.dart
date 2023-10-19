import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_project/provider/env_news.dart';

import 'package:news_project/provider/list_provider.dart';
import 'package:news_project/provider/news_provider.dart';
import 'package:news_project/screens/startpage.dart';
import 'package:provider/provider.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NewsProvider>(
            create: (context) => NewsProvider()),
        ChangeNotifierProvider<ListProvider>(
            create: (context) => ListProvider()),
        ChangeNotifierProvider<EnvProvider>(
            create: (context) => EnvProvider())
      ], // Create and provide the NewsProvider
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              title: Text(
                'News Today',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold, fontSize: 25),
              ),
              centerTitle: true,
            ),
            body: StartPage()),
      ),
    );
  }
}
