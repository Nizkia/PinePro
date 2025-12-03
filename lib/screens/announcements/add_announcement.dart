import 'package:flutter/material.dart';
import 'package:pinepro/db/database_helper.dart';
import 'package:pinepro/models/announcement.dart';

class AddAnnouncement extends StatefulWidget {
  final int entrepreneurId;   // 🔹 REQUIRED

  const AddAnnouncement({super.key, required this.entrepreneurId});

  @override
  State<AddAnnouncement> createState() => _AddAnnouncementState();
}

class _AddAnnouncementState extends State<AddAnnouncement> {
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final messageController = TextEditingController();
  final dateController = TextEditingController();

  Future<void> saveAnnouncement() async {
    if (_formKey.currentState!.validate()) {
      final newAnnouncement = Announcement(
        id: null,
        entrepreneurId: widget.entrepreneurId,      // 🔹 IMPORTANT
        title: titleController.text.trim(),
        message: messageController.text.trim(),
        date: dateController.text.trim(),
      );

      final db = await DatabaseHelper.instance.database;

      await db.insert('announcements', newAnnouncement.toMap());

      Navigator.pop(context, true); // return success
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Announcement")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Title",
                ),
                validator: (value) =>
                value!.isEmpty ? "Enter title" : null,
              ),
              TextFormField(
                controller: messageController,
                decoration: const InputDecoration(
                  labelText: "Message",
                ),
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
                child: const Text("Save"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
