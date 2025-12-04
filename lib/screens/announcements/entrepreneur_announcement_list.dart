import 'package:flutter/material.dart';
import 'package:pinepro/db/database_helper.dart';
import 'package:pinepro/models/announcement.dart';
import 'package:pinepro/models/user.dart';
import '../feedback/feedback_page.dart';
import 'add_or_edit_announcement.dart';

class EntrepreneurAnnouncementList extends StatefulWidget {
  final User loggedInUser;

  const EntrepreneurAnnouncementList({super.key, required this.loggedInUser});

  @override
  State<EntrepreneurAnnouncementList> createState() =>
      _EntrepreneurAnnouncementListState();
}

class _EntrepreneurAnnouncementListState
    extends State<EntrepreneurAnnouncementList> {
  List<Announcement> announcements = [];

  @override
  void initState() {
    super.initState();
    loadAnnouncements();
  }

  Future<void> loadAnnouncements() async {
    final db = await DatabaseHelper.instance.database;
    final data = await db.query("announcements"); // fetch all announcements

    setState(() {
      announcements = data.map((item) => Announcement.fromMap(item)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final content = announcements.isEmpty
        ? const Center(child: Text("No announcements yet."))
        : ListView.builder(
      itemCount: announcements.length,
      itemBuilder: (ctx, index) {
        final a = announcements[index];
        final canEditDelete =
            a.entrepreneurId == widget.loggedInUser.id; // only own

        return Card(
          margin:
          const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: ListTile(
            title: Text(a.title),
            subtitle: Text("${a.message}\n📅 ${a.date}"),
            isThreeLine: true,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FeedbackPage(
                    announcementId: a.id!,
                    loggedInUser: widget.loggedInUser,
                  ),
                ),
              );
            },
            trailing: canEditDelete
                ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon:
                  const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () async {
                    final updated = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddOrEditAnnouncement(
                          entrepreneurId: a.entrepreneurId!,
                          announcement: a,
                        ),
                      ),
                    );
                    if (updated == true) loadAnnouncements();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    final db =
                    await DatabaseHelper.instance.database;
                    await db.delete(
                      "announcements",
                      where: "id = ?",
                      whereArgs: [a.id!],
                    );
                    loadAnnouncements();
                  },
                ),
              ],
            )
                : null,
          ),
        );
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text("All Announcements")),
      body: content,
    );
  }
}
