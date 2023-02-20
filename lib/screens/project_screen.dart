import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:research_data_collector/reusable_widgets/dynamic_form.dart';
import 'package:research_data_collector/screens/form_create_screen.dart';
import 'package:research_data_collector/screens/login_screen.dart';

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({Key? key}) : super(key: key);

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // FirebaseAuth.instance.signOut().then((value) {
            //   print("Signed out");
            //   Navigator.push(context, MaterialPageRoute(builder: (context) => LogInScreen()));
            // });
            Navigator.push(context, MaterialPageRoute(builder: (context) => DynamicForm()));
          },
          child: Text(
            "create form",
          ),
        ),
      ),
    );
  }
}
