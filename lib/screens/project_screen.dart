import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:research_data_collector/reusable_widgets/dynamic_form.dart';
import 'package:research_data_collector/screens/form_create_screen.dart';
import 'package:research_data_collector/screens/form_screen.dart';
import 'package:research_data_collector/screens/login_screen.dart';
import 'package:research_data_collector/screens/fill_form.dart';
import 'package:research_data_collector/screens/my_project.dart';

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({Key? key}) : super(key: key);

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Home"),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'My Projects', icon: Icon(Icons.my_library_books)),
              Tab(text: 'Submitted', icon: Icon(Icons.upload_file)),
              Tab(text: 'Add Project', icon: Icon(Icons.book))
            ],
          ),
          actions: <Widget>[
            Stack(
              children: <Widget>[
                IconButton(
                    icon: const Icon(Icons.notifications),
                    onPressed: () {
                      setState(() {
                        counter = 0;
                      });
                    }),
                counter != 0 ? Positioned(
                  right: 11,
                  top: 11,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(6)),
                    constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                    child: Text('$counter',
                      style: const TextStyle(color: Colors.white, fontSize: 8),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
                    : Container()
              ],
            ),
          ],
        ),
        body: const TabBarView(
          children: [
            MyProjects(),
            FormScreen(formId: '0D3y6UcGjV2XHAYhEzKM'),
            DynamicForm(),
            // Forms()
          ],
        ),
      ),
    );
  }
}
