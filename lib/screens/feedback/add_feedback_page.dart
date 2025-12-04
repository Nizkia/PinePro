import 'package:flutter/material.dart';
import 'package:pinepro/db/feedback_dao.dart';
import 'package:pinepro/models/feedback.dart';

import '../../models/user.dart';

class AddFeedbackPage extends StatefulWidget {
  final int announcementId;
  final FeedbackModel? existingFeedback;
  final User loggedInUser;

  const AddFeedbackPage({
    super.key,
    required this.announcementId,
    this.existingFeedback,
    required this.loggedInUser,
  });

  @override
  State<AddFeedbackPage> createState() => _AddFeedbackPageState();
}

class _AddFeedbackPageState extends State<AddFeedbackPage> {
  final TextEditingController _controller = TextEditingController();
  static const int currentUserId = 1; // Replace with real session user ID
  static const String currentUsername = "Current User"; // Replace with session username

  @override
  void initState() {
    super.initState();
    if (widget.existingFeedback != null) {
      _controller.text = widget.existingFeedback!.comment;
    }
  }

  Future<void> _submitFeedback() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    if (widget.existingFeedback != null) {
      // Update existing feedback
      final fb = widget.existingFeedback!;
      fb.comment = text;
      fb.date = DateTime.now().toString();
      await FeedbackDAO.updateFeedback(fb);
    } else {
      // Insert new feedback
      final newFb = FeedbackModel(
        id: null,
        announcementId: widget.announcementId,
        userId: widget.loggedInUser.id!,
        username: widget.loggedInUser.name,
        comment: text,
        date: DateTime.now().toString(),
      );
      await FeedbackDAO.insertFeedback(newFb);
    }

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingFeedback != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Edit Feedback" : "Add Feedback"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: "Write your feedback here...",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitFeedback,
              child: Text(isEditing ? "Update" : "Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
