import 'package:flutter/material.dart';
import 'package:pinepro/db/database_helper.dart';
import 'package:pinepro/models/announcement.dart';
import 'package:pinepro/models/user.dart';
import '../feedback/feedback_page.dart';
import 'add_or_edit_announcement.dart';

class AnnouncementList extends StatefulWidget {
  /// Logged-in user to control permissions
  final User loggedInUser;

  /// If provided → Only show this entrepreneur’s announcements
  final int? entrepreneurId;

  /// If true → No Scaffold, because this widget lives inside another page
  final bool embedded;

  const AnnouncementList({
    super.key,
    required this.loggedInUser,
    this.entrepreneurId,
    this.embedded = false,
  });

  @override
  State<AnnouncementList> createState() => _AnnouncementListState();
}

class _AnnouncementListState extends State<AnnouncementList> {
  List<Announcement> announcements = [];

  @override
  void initState() {
    super.initState();
    loadAnnouncements();
  }

  Future<void> loadAnnouncements() async {
    final db = await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> data;

    // Show only this entrepreneur’s announcements if entrepreneurId is set
    if (widget.entrepreneurId != null) {
      data = await db.query(
        "announcements",
        where: "entrepreneurId = ?",
        whereArgs: [widget.entrepreneurId],
      );
    } else {
      // All announcements
      data = await db.query("announcements");
    }

    setState(() {
      announcements =
          data.map((item) => Announcement.fromMap(item)).toList();
    });
  }

  Future<void> deleteAnnouncement(int id) async {
    final db = await DatabaseHelper.instance.database;

    await db.delete(
      "announcements",
      where: "id = ?",
      whereArgs: [id],
    );

    loadAnnouncements();
  }

  @override
  Widget build(BuildContext context) {
    final isEntrepreneur = widget.loggedInUser.role == "entrepreneur";

    final content = announcements.isEmpty
        ? const Center(child: Text("No announcements yet."))
        : ListView.builder(
      itemCount: announcements.length,
      itemBuilder: (ctx, index) {
        final a = announcements[index];

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: ListTile(
            title: Text(a.title),
            subtitle: Text("${a.message}\n📅 ${a.date}"),
            isThreeLine: true,

            // Navigate to FeedbackPage when tapped
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

            // EDIT + DELETE buttons visible only for entrepreneurs
            trailing: isEntrepreneur
                ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () async {
                    final updated = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddOrEditAnnouncement(
                          entrepreneurId: widget.entrepreneurId!,
                          announcement: a,
                        ),
                      ),
                    );
                    if (updated == true) loadAnnouncements();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => deleteAnnouncement(a.id!),
                ),
              ],
            )
                : null,
          ),
        );
      },
    );

    // If embedded inside another page → no Scaffold
    if (widget.embedded) return content;

    return Scaffold(
      appBar: AppBar(title: const Text("Announcements")),

      // Add button visible only for entrepreneurs
      floatingActionButton: isEntrepreneur
          ? FloatingActionButton(
        onPressed: () async {
          final saved = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddOrEditAnnouncement(
                entrepreneurId: widget.entrepreneurId!,
                announcement: null,
              ),
            ),
          );
          if (saved == true) loadAnnouncements();
        },
        child: const Icon(Icons.add),
      )
          : null,

      body: content,
    );
  }
}
