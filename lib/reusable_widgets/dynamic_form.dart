import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:research_data_collector/screens/project_screen.dart';

class DynamicForm extends StatefulWidget {
  const DynamicForm({Key? key}) : super(key: key);

  @override
  State<DynamicForm> createState() => _DynamicFormState();
}

class _DynamicFormState extends State<DynamicForm> {
  final List<TextEditingController> _nameControllers = [];
  final List<String> _typeOptions = ['Select Type', 'Number', 'Text', 'Image', 'Audio'];
  final List<String> _typeSelections = [];

  void _addFormField() {
    final nameController = TextEditingController();
    _nameControllers.add(nameController);
    _typeSelections.add(_typeOptions.first);
    setState(() {});
  }

  void _removeFormField(int index) {
    _nameControllers.removeAt(index);
    _typeSelections.removeAt(index);
    setState(() {});
  }

  Future<void> _handleSubmit() async {
    var inputsArray = [];
    final Map<String, dynamic> formValues = {};
    for (int i = 0; i < _nameControllers.length; i++) {
      final Map<String, dynamic> formValues = {};
      formValues["key"] = _nameControllers[i].text;
      formValues["value"] = _typeSelections[i];
      inputsArray.add(formValues);
    }

    final docFields = FirebaseFirestore.instance.collection("form_fields").doc();

    var userId = await getUserId();
    await docFields.set({"formFields": inputsArray, "createdBy": userId}).then((value) {
      print("Success");
      Navigator.push(context, MaterialPageRoute(builder: (context) => ProjectScreen()));
    }).onError((error, stackTrace) {
      print("Error ${error.toString()}");
    });
    print('Form values pushed to Firebase: $inputsArray');
  }

  bool _formIsValid() {
    if (_nameControllers.isEmpty) {
      return false;
    }
    for (int i = 0; i < _nameControllers.length; i++) {
      if (_nameControllers[i].text.isEmpty || _typeOptions[i] == 'Select Type') {
        return false;
      }
    }
    return true;
  }

  @override
  void dispose() {
    _nameControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dynamic Form'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _nameControllers.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: Colors.grey.shade300, width: 1.0),
                  ),
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _nameControllers[index],
                            decoration: InputDecoration(
                              labelText: 'Field Name ${index + 1}',
                            ),
                          ),
                        ),
                        SizedBox(width: 16.0),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _typeSelections[index],
                            items: _typeOptions
                                .map((type) => DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            ))
                                .toList(),
                            onChanged: (value) {
                              _typeSelections[index] = value!;
                              setState(() {});
                            },
                            decoration: InputDecoration(
                              labelText: 'Data Type ${index + 1}',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.green),
                onPressed: _addFormField,
                child: Text('+ Field'),
              ),
              SizedBox(width: 16.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.red),
                onPressed: _nameControllers.isNotEmpty ? () => _removeFormField(_nameControllers.length - 1) : null,
                child: Text('- Field'),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              // onPressed: _formIsValid == true ? () => _handleSubmit : null,
              onPressed: _handleSubmit,
              child: Text('Submit'),
            ),
          ),
        ],
      ),
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
      return values.elementAt(0).toString();
    }
    return null;
  }
}
