import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class FormScreen extends StatefulWidget {
  //final Function setImage;
  final String formId;
  const FormScreen({Key? key, required this.formId}) : super(key: key);

  // ImageInput(this.setImage);

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  List<String> fields = ['Name', 'Email', 'Phone'];
  late Map<String, dynamic>? data;
  late String title = '';
  late String description = '';
  late List<Map<String, dynamic>> dataFields = [];

  late File _imageFile;

  void _getImage(BuildContext context, ImageSource source) async {
    final pickedFile = await ImagePicker().getImage(
      source: source,
    );

    // setState(() async {
    // //   if (pickedFile != null) {
    // //     _imageFile = File(pickedFile.path);
    // //     widget.setImage(_imageFile);
    // //   } else {
    // //     print('No image selected.');
    // //   }
    // });

    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('form_fields')
        .doc(widget.formId)
        .get()
        .then((snapshot) {
      setState(() {
        data = snapshot.data();
        title = data?['projectName'];
        description = data?['projectDescription'];
        print(data?['formFields']);
      });
    });
  }

  void _openImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text('Camera'),
                  onTap: () {
                    _getImage(context, ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Gallery'),
                  onTap: () {
                    _getImage(context, ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                for (var field in fields)
                  if (field == 'Email')
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: field,
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter $field';
                        } else if (!isEmail(value!)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                    )
                  else if (field == 'Phone')
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: field,
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter $field';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    )
                  else
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: field,
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter $field';
                        }
                        return null;
                      },
                    ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Do something with the form data
                    }
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
}

bool isEmail(String value) {
  if(value.contains('@')){
    return true;
  }
  return false;
}
