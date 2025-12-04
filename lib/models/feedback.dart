class FeedbackModel {
  int? id;
  int announcementId;
  int userId;
  String username; // <- must match query alias 'username'
  String comment;
  String date;

  FeedbackModel({
    this.id,
    required this.announcementId,
    required this.userId,
    required this.username,
    required this.comment,
    required this.date,
  });

  factory FeedbackModel.fromMap(Map<String, dynamic> map) {
    return FeedbackModel(
      id: map['id'],
      announcementId: map['announcementId'],
      userId: map['userId'],
      username: map['username'] ?? "Unknown", // fallback
      comment: map['comment'],
      date: map['date'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'announcementId': announcementId,
      'userId': userId,
      'comment': comment,
      'date': date,
      // username is not stored in DB, only used for display
    };
  }
}
