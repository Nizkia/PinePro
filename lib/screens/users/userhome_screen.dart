import 'package:flutter/material.dart';
import '../auth/login_screen.dart';
import '../entrepreneurs/entrepreneur_list.dart';
import '../announcements/announcement_list.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Entrepreneurs + Announcements
      child: Scaffold(
        appBar: AppBar(
          title: const Text("PinePro"),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                );
              },
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.store), text: "Entrepreneurs"),
              Tab(icon: Icon(Icons.campaign), text: "Announcements"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            EntrepreneurList(),  // list of entrepreneurs
            AnnouncementList(),  // list of announcements
          ],
        ),
      ),
    );
  }
}
