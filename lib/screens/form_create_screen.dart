import 'package:flutter/material.dart';

class FormCreateScreen extends StatefulWidget {
  const FormCreateScreen({Key? key}) : super(key: key);

  @override
  State<FormCreateScreen> createState() => _FormCreateScreenState();
}

class _FormCreateScreenState extends State<FormCreateScreen> {

  late int _count;
  
  @override
  void initState() {
    super.initState();
    _count = 0;
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dynamic Form"),
        actions: [
          IconButton(
              onPressed: () async{
                setState(() {
                  _count++;
                });
              },
              icon: Icon(Icons.add)
          ),
          IconButton(
              onPressed: () async{
                setState(() {
                  _count--;
                });
              },
              icon: Icon(Icons.exposure_minus_1)
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Flexible(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _count,
                    itemBuilder: (context, index) {
                      return _row(index);
                    }
                )
            )
          ],
        ),
      ),
    );
  }

  _row(int index) {
    return Row(
      children: [
        Text("ID"),
        SizedBox(width: 30.0),
        Expanded(child: TextFormField())
      ],
    );
  }
}

