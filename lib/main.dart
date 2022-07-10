import 'package:bot_toast/bot_toast.dart';
import 'package:ev_bunk/firebase_options.dart';
import 'package:ev_bunk/pages/Nav_Bar.dart';
import 'package:ev_bunk/pages/homePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      builder: BotToastInit(), //1. call BotToastInit
      navigatorObservers: [BotToastNavigatorObserver()], //2.

      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',

      routes: {
        '/': (context) => Nav_Bar(),
      },
      // home: Nav_Bar(),
    );
  }
}
