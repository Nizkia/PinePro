class Announcement {
  int? id;
  final int entrepreneurId;
  String title;
  String message;
  String date;

  Announcement({
    this.id,
    required this.entrepreneurId,
    required this.title,
    required this.message,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'entrepreneurId': entrepreneurId,
      'title': title,
      'message': message,
      'date': date,
    };
  }

  factory Announcement.fromMap(Map<String, dynamic> map) {
    return Announcement(
      id: map['id'],
      entrepreneurId: map['entrepreneurId'],
      title: map['title'],
      message: map['message'],
      date: map['date'],
    );
  }
}
