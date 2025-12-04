import 'package:pinepro/db/database_helper.dart';
import 'package:pinepro/models/feedback.dart';

class FeedbackDAO {
  static Future<int> insertFeedback(FeedbackModel fb) async {
    final db = await DatabaseHelper.instance.database;
    return await db.insert("feedback", fb.toMap());
  }

  static Future<int> updateFeedback(FeedbackModel fb) async {
    final db = await DatabaseHelper.instance.database;
    return await db.update(
      "feedback",
      fb.toMap(),
      where: "id = ? AND userId = ?",
      whereArgs: [fb.id, fb.userId],
    );
  }

  static Future<int> deleteFeedback(FeedbackModel fb) async {
    final db = await DatabaseHelper.instance.database;
    return await db.delete(
      "feedback",
      where: "id = ? AND userId = ?",
      whereArgs: [fb.id, fb.userId],
    );
  }

  static Future<List<FeedbackModel>> getFeedbacks(int announcementId) async {
    final db = await DatabaseHelper.instance.database;

    // Make sure to JOIN users table to get the username
    final result = await db.rawQuery('''
      SELECT f.id, f.announcementId, f.userId, f.comment, f.date, u.name as username
      FROM feedback f
      INNER JOIN users u ON f.userId = u.id
      WHERE f.announcementId = ?
      ORDER BY f.date DESC
    ''', [announcementId]);

    // Map query results to FeedbackModel
    return result.map((e) => FeedbackModel.fromMap(e)).toList();
  }
}
