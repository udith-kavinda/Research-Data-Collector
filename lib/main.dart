import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:research_data_collector/screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Future<FirebaseApp> _initializeFirbase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _initializeFirbase(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            return LogInScreen();
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      )
    );
  }
}


