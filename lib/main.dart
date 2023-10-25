import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_project/Adaptors/hive_adp.dart';
import 'package:news_project/firebase_options.dart';
import 'package:news_project/provider/Bookmarkprovider.dart';
import 'package:news_project/provider/env_news.dart';

import 'package:news_project/provider/list_provider.dart';
import 'package:news_project/provider/news_provider.dart';
import 'package:news_project/screens/startpage.dart';
import 'package:news_project/utils/navbar.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:hive_flutter/hive_flutter.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Register the Hive adapter for your NewsModel
  Hive.registerAdapter(NewsModelAdapter());

  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();

  // Open a Hive box for your NewsModel with the specified path
  await Hive.openBox<NewsModelAdp>('BookMark', path: appDocumentDir.path);
  print(Hive.isBoxOpen('BookMark'));
  print(Hive.box<NewsModelAdp>('BookMark').values.length.toString());
  // Hive.box<NewsModelAdp>('BookMark').clear();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NewsProvider>(
            create: (context) => NewsProvider()),
        ChangeNotifierProvider<ListProvider>(
            create: (context) => ListProvider()),
        ChangeNotifierProvider<BookmarkProvider>(
            create: (context) => BookmarkProvider()),
        ChangeNotifierProvider<EnvProvider>(create: (context) => EnvProvider())
      ], // Create and provide the NewsProvider
      child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          home: ValueListenableBuilder(
            valueListenable: Hive.box<NewsModelAdp>('BookMark').listenable(),
            builder: (context, value, child) {
              return StreamBuilder<User?>(
                  stream: _auth.authStateChanges(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: SpinKitFoldingCube(
                          size: 40,
                          color: Colors.orange,
                        ),
                      );
                    } else {
                      if (snapshot.hasData) {
                        return RootPage();
                      } else {
                        return StartPage();
                      }
                    }
                  });
            },
          )),
    );
  }
}
