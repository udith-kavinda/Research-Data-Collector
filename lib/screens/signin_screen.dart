import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:research_data_collector/reusable_widgets/reusable_widget.dart';
import 'package:research_data_collector/screens/login_screen.dart';
import 'package:research_data_collector/screens/project_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  TextEditingController _passwordController = TextEditingController();
  TextEditingController _emailTextcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign In",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.black, Colors.black38],
          begin: Alignment.topCenter, end: Alignment.bottomCenter)
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).size.height * 0.2, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter email", Icons.person_outline, false, _emailTextcontroller),
                SizedBox(height: 20),
                reusableTextField("Enter password", Icons.lock_outlined, true, _passwordController),
                SizedBox(
                  height: 30,
                ),
                logInSignInButton(context, false, (){
                  FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: _emailTextcontroller.text,
                      password: _passwordController.text
                  ).then((value) async {
                    await createUser(email: _emailTextcontroller.text).then((value) {
                      print("Created new user");
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ProjectScreen()));
                    }).onError((error, stackTrace) {
                      print("Error ${error.toString()}");
                    });
                  }).onError((error, stackTrace) {
                    print("Error ${error.toString()}");
                  });
                }),
                logInOption()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row logInOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Already have an account? ",
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => LogInScreen()));
          },
          child: const Text(
            "Log In",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  Future createUser({required String email}) async {
    final docUser = FirebaseFirestore.instance.collection("users").doc();

    final user = User(
      id: docUser.id,
      email: email
    );

    final userData = user.toJson();
    await docUser.set(userData);
  }
}

class User {
  String id;
  final String email;

  User({
    this.id = '',
    required this.email
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email
  };

}
