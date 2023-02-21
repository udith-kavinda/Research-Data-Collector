import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:research_data_collector/reusable_widgets/dynamic_form.dart';

class MyProjects extends StatefulWidget {
  const MyProjects({Key? key}) : super(key: key);

  @override
  State<MyProjects> createState() => _MyProjectsState();
}

class _MyProjectsState extends State<MyProjects> {
  late var data;
  late String title = '';
  late String description = '';
  late List<Map<String, dynamic>> dataFields = [];

  @override
  void initState() {
    super.initState();
    getUserId().then((value) =>
        FirebaseFirestore.instance
            .collection('form_fields')
            .where("createdBy", isEqualTo: value)
            .get()
            .then((snapshot) {
          setState(() {
            data = snapshot.docs.map((e) => e['projectName']);
            print(data);
          });
        }),
    ).onError((error, stackTrace) {
      print("Error ${error.toString()}");
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
        padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
              child: Column(
                  children: [
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => DynamicForm()));
                        },
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 54,
                        ),
                        style: ElevatedButton.styleFrom(
                            shape: CircleBorder(), //<-- SEE HERE
                            padding: EdgeInsets.all(20),
                        ),
                      ),
                    )
                  //   for (var field in data)
                  //     TextFormField(
                  //       decoration: InputDecoration(
                  //         labelText: field,
                  //       ),
                  //       validator: (value) {
                  //         if (value!.isEmpty) {
                  //           return 'Please enter $field';
                  //         } else if (!isEmail(value!)) {
                  //           return 'Please enter a valid email address';
                  //         }
                  //         return null;
                  //       },
                  //       keyboardType: TextInputType.emailAddress,
                  //       textInputAction: TextInputAction.next,
                  //     )
                  ]
              )
          )
        )
    );
  }
  Future<String?> getUserId() async {
    FirebaseAuth authUser = FirebaseAuth.instance;
    FirebaseDatabase user = FirebaseDatabase.instance;

    if(user != null && authUser != null){
      var email = authUser.currentUser?.email;
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("users")
          .where("email", isEqualTo: email)
          .get();
      var values = querySnapshot.docs.map((e) => e.id);
      print(values.elementAt(0).toString());
      return values.elementAt(0).toString();
    }
    return null;
  }
}

