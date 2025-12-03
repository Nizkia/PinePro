import 'package:flutter/material.dart';
import 'auth/login_screen.dart';
import 'entrepreneurs/entrepreneur_list.dart';
import 'announcements/announcement_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // ENTREPRENEURS BUTTON
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const EntrepreneurList(),
                  ),
                );
              },
              child: const Text("Entrepreneurs"),
            ),

            const SizedBox(height: 20),

            // ANNOUNCEMENTS BUTTON
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AnnouncementList(),
                  ),
                );
              },
              child: const Text("Announcements"),
            ),
          ],
        ),
      ),
    );
  }
}
