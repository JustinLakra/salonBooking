// ignore_for_file: non_constant_identifier_names, unrelated_type_equality_checks


import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'Components/utils.dart';
import 'Login/auth_page.dart';
import 'Login/verifyemail.dart';
import 'firebase_options.dart';
import 'home/home.dart';
import 'package:salon/home/mainPage.dart';


//Defining navigator key to ease the popping and pushing of routes in login, signup, etc
final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  //Initializing Firebase App
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //After initialization, building material app
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  void initState() {
    super.initState();
  }

  final Widget to_be = const MainPage();


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: Utils.messengerKey,
      navigatorKey: navigatorKey,
      home: to_be,
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  //Listening for auth changes from Firebase Auth via streams
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#4169E1"),
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(
                child: Text("Something Went Wrong!!"),
              );
            } else if (snapshot.hasData) {
              return const mainPage();
            } else {
              return const AuthPage();
            }
          }),
    );
  }
}
