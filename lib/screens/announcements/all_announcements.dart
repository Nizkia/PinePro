import 'package:flutter/material.dart';
import 'package:pinepro/models/user.dart';


import 'entrepreneur_announcement_list.dart';

class AllAnnouncementsPage extends StatelessWidget {
  final User loggedInUser;

  const AllAnnouncementsPage({super.key, required this.loggedInUser});

  @override
  Widget build(BuildContext context) {
    return EntrepreneurAnnouncementList(loggedInUser: loggedInUser);
  }
}

