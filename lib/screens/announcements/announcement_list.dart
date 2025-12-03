import 'package:flutter/material.dart';
import 'package:pinepro/db/database_helper.dart';
import 'package:pinepro/models/announcement.dart';
import 'add_or_edit_announcement.dart';

class AnnouncementList extends StatefulWidget {
  /// If provided → Only show this entrepreneur’s announcements
  final int? entrepreneurId;

  /// If true → No Scaffold, because this widget lives inside another page
  final bool embedded;

  const AnnouncementList({
    super.key,
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

    if (widget.entrepreneurId != null) {
      data = await db.query(
        "announcements",
        where: "entrepreneurId = ?",
        whereArgs: [widget.entrepreneurId],
      );
    } else {
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
    final content = announcements.isEmpty
        ? const Center(child: Text("No announcements yet."))
        : ListView.builder(
      itemCount: announcements.length,
      itemBuilder: (ctx, index) {
        final a = announcements[index];

        return Card(
          margin:
          const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: ListTile(
            title: Text(a.title),
            subtitle: Text("${a.message}\n📅 ${a.date}"),
            isThreeLine: true,

            // EDIT + DELETE only if this list belongs to this entrepreneur
            trailing: widget.entrepreneurId != null
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
                  onPressed: () {
                    deleteAnnouncement(a.id!);
                  },
                ),
              ],
            )
                : null, // No edit/delete in public/admin mode
          ),
        );
      },
    );

    if (widget.embedded) return content;

    // Full page mode (admin/customer)
    return Scaffold(
      appBar: AppBar(title: const Text("Announcements")),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final saved = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddOrEditAnnouncement(
                entrepreneurId: widget.entrepreneurId ?? 0,
                announcement: null,
              ),
            ),
          );
          if (saved == true) loadAnnouncements();
        },
        child: const Icon(Icons.add),
      ),
      body: content,
    );
  }
}
