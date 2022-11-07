import 'package:flutter/material.dart';

import '../models/login_functions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
        actions: [
          IconButton(
            onPressed: () {
              LoginFunctions.logout(context);
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
    );
  }
}
