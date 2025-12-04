import 'package:flutter/material.dart';
import 'package:pinepro/db/feedback_dao.dart';
import 'package:pinepro/models/feedback.dart';
import 'package:pinepro/models/announcement.dart';
import '../../db/database_helper.dart';
import 'add_feedback_page.dart';
import '../../models/user.dart';

class FeedbackPage extends StatefulWidget {
  final int announcementId;
  final User loggedInUser; // ✅ Pass logged-in user

  const FeedbackPage({
    super.key,
    required this.announcementId,
    required this.loggedInUser,
  });

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  Announcement? _announcement;
  List<FeedbackModel> _allFeedbacks = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _loadAnnouncement();
    await _loadFeedbacks();
  }

  Future<void> _loadAnnouncement() async {
    final db = await DatabaseHelper.instance.database;
    final data = await db.query(
      "announcements",
      where: "id = ?",
      whereArgs: [widget.announcementId],
    );
    if (data.isNotEmpty) {
      setState(() {
        _announcement = Announcement.fromMap(data.first);
      });
    }
  }

  Future<void> _loadFeedbacks() async {
    final feedbacks = await FeedbackDAO.getFeedbacks(widget.announcementId);
    setState(() {
      _allFeedbacks = feedbacks;
    });
  }

  Future<void> _deleteFeedback(FeedbackModel fb) async {
    await FeedbackDAO.deleteFeedback(fb);
    await _loadFeedbacks();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = widget.loggedInUser.id!;
    final currentUserRole = widget.loggedInUser.role;
    final isEntrepreneur = currentUserRole == "entrepreneur";

    return Scaffold(
      appBar: AppBar(title: const Text("Announcement & Feedback")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_announcement != null) ...[
              Text(
                _announcement!.title,
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(_announcement!.message,
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Text(
                "📅 ${_announcement!.date}",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const Divider(height: 32),
            ],

            Expanded(
              child: _allFeedbacks.isEmpty
                  ? const Center(
                  child: Text("No feedback has been submitted yet."))
                  : ListView.builder(
                itemCount: _allFeedbacks.length,
                itemBuilder: (context, index) {
                  final fb = _allFeedbacks[index];
                  final isOwner = fb.userId == currentUserId;

                  return Card(
                    child: ListTile(
                      title: Text(fb.comment),
                      subtitle: Text("By ${fb.username} 📅 ${fb.date}"),
                      trailing: (!isEntrepreneur && isOwner)
                          ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit,
                                color: Colors.blue),
                            onPressed: () async {
                              final result =
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AddFeedbackPage(
                                    announcementId:
                                    widget.announcementId,
                                    existingFeedback: fb,
                                    loggedInUser: widget.loggedInUser,
                                  ),
                                ),
                              );
                              if (result == true)
                                await _loadFeedbacks();
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete,
                                color: Colors.red),
                            onPressed: () =>
                                _deleteFeedback(fb),
                          ),
                        ],
                      )
                          : null,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: !isEntrepreneur
          ? FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddFeedbackPage(
                announcementId: widget.announcementId,
                existingFeedback: null,
                loggedInUser: widget.loggedInUser,
              ),
            ),
          );
          if (result == true) await _loadFeedbacks();
        },
        child: const Icon(Icons.add),
      )
          : null,
    );
  }
}
