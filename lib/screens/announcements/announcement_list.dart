import 'package:flutter/material.dart';
import 'package:pinepro/db/database_helper.dart';
import 'package:pinepro/models/announcement.dart';
import 'add_announcement.dart';

class AnnouncementList extends StatefulWidget {
  const AnnouncementList({super.key});

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
    final data = await db.query('announcements');
    setState(() {
      announcements =
          data.map((item) => Announcement.fromMap(item)).toList();
    });
  }

  Future<void> deleteAnnouncement(int id) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete(
      'announcements',
      where: 'id = ?',
      whereArgs: [id],
    );
    loadAnnouncements();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Announcements")),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddAnnouncement(),
            ),
          );
          if (result == true) loadAnnouncements();
        },
        child: const Icon(Icons.add),
      ),
      body: announcements.isEmpty
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
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  deleteAnnouncement(a.id!);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
