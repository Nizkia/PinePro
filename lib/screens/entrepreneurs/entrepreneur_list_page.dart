import 'package:flutter/material.dart';
import 'package:pinepro/models/user.dart';
import 'entrepreneur_list.dart';

class EntrepreneurListPage extends StatelessWidget {
  final User loggedInUser;

  const EntrepreneurListPage({super.key, required this.loggedInUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Entrepreneurs"),
      ),
      body: EntrepreneurList(
        loggedInUser: loggedInUser,
      ),
    );
  }
}
