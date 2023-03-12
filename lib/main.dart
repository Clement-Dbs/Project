import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project/firebase_options.dart';
import 'package:project/pageConnexion.dart';
import 'package:project/PageCreationCompte.dart';
import 'package:project/pageMenu.dart';
import 'package:project/pagePassOublié.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Steam Like App',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/createaccount': (context) => CreateAccountPage(),
        '/menu': (context) => MenuPage(),
        '/passforget': (context) => PassForgetPage(),
      },
      /*home: LoginPage(),*/
    );
  }
}

