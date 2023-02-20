import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:research_data_collector/reusable_widgets/reusable_widget.dart';
import 'package:research_data_collector/screens/project_screen.dart';
import 'package:research_data_collector/screens/signin_screen.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {

  TextEditingController _passwordController = TextEditingController();
  TextEditingController _emailTextcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          height: 800.00,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.black, Colors.black38]
              ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).size.height *0.2, 20, 0),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  reusableTextField("Enter email", Icons.person_outline, false, _emailTextcontroller),
                  SizedBox(height: 20),
                  reusableTextField("Enter password", Icons.lock_outlined, true, _passwordController),
                  SizedBox(
                    height: 30,
                  ),
                  logInSignInButton(context, true, (){
                    FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: _emailTextcontroller.text,
                        password: _passwordController.text
                    ).then((value) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ProjectScreen()));
                    }).onError((error, stackTrace) {
                      print('Error ${error.toString()}');
                    });
                  }),
                  signInOption()
                ],
              ),
            ),
          ),
        ),
    );
  }

  Row signInOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have account? ",
        style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => SignInScreen()));
          },
          child: const Text(
            "Sign In",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
