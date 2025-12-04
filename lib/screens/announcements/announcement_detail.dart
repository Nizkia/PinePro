import 'package:flutter/material.dart';
import 'package:pinepro/models/announcement.dart';
import '../../models/user.dart';
import '../feedback/feedback_page.dart';

class AnnouncementDetail extends StatelessWidget {
  final Announcement announcement;
  final User loggedInUser;

  const AnnouncementDetail({
    super.key,
    required this.announcement,
    required this.loggedInUser,
  });

  @override
  Widget build(BuildContext context) {
    final isNormalUser = loggedInUser.role != "entrepreneur";

    return Scaffold(
      appBar: AppBar(title: Text(announcement.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              announcement.title,
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(announcement.message),
            const SizedBox(height: 10),
            Text("📅 ${announcement.date}"),
            const Divider(height: 30),
            const Text("Feedbacks:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
      floatingActionButton: isNormalUser
          ? FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FeedbackPage(
                announcementId: announcement.id!,
                loggedInUser: loggedInUser,
              ),
            ),
          );
        },
        child: const Icon(Icons.add_comment_rounded),
      )
          : null,
    );
  }
}
