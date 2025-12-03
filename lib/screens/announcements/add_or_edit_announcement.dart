import 'package:flutter/material.dart';
import 'package:pinepro/db/database_helper.dart';
import 'package:pinepro/models/announcement.dart';

class AddOrEditAnnouncement extends StatefulWidget {
  final int entrepreneurId;
  final Announcement? announcement; // null → add mode

  const AddOrEditAnnouncement({
    super.key,
    required this.entrepreneurId,
    this.announcement,
  });

  @override
  State<AddOrEditAnnouncement> createState() => _AddOrEditAnnouncementState();
}

class _AddOrEditAnnouncementState extends State<AddOrEditAnnouncement> {
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final messageController = TextEditingController();
  final dateController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.announcement != null) {
      // EDIT MODE: prefill fields
      titleController.text = widget.announcement!.title;
      messageController.text = widget.announcement!.message;
      dateController.text = widget.announcement!.date;
    }
  }

  Future<void> saveAnnouncement() async {
    final db = await DatabaseHelper.instance.database;

    if (!_formKey.currentState!.validate()) return;

    if (widget.announcement == null) {
      // ADD MODE
      final newAnnouncement = Announcement(
        id: null,
        entrepreneurId: widget.entrepreneurId,
        title: titleController.text.trim(),
        message: messageController.text.trim(),
        date: dateController.text.trim(),
      );

      await db.insert("announcements", newAnnouncement.toMap());
    } else {
      // EDIT MODE
      final updated = Announcement(
        id: widget.announcement!.id,
        entrepreneurId: widget.announcement!.entrepreneurId,
        title: titleController.text.trim(),
        message: messageController.text.trim(),
        date: dateController.text.trim(),
      );

      await db.update(
        "announcements",
        updated.toMap(),
        where: "id = ?",
        whereArgs: [updated.id],
      );
    }

    Navigator.pop(context, true); // return success
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.announcement != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit Announcement" : "Add Announcement"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Title"),
                validator: (value) =>
                value!.isEmpty ? "Enter title" : null,
              ),
              TextFormField(
                controller: messageController,
                decoration: const InputDecoration(labelText: "Message"),
                validator: (value) =>
                value!.isEmpty ? "Enter message" : null,
              ),
              TextFormField(
                controller: dateController,
                decoration: const InputDecoration(
                  labelText: "Date (e.g. 5 Dec 2025)",
                ),
                validator: (value) =>
                value!.isEmpty ? "Enter date" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveAnnouncement,
                child: Text(isEdit ? "Update" : "Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
