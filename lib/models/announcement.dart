class Announcement {
  int? id;
  String title;
  String message;
  String date;

  Announcement({
    this.id,
    required this.title,
    required this.message,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'date': date,
    };
  }

  factory Announcement.fromMap(Map<String, dynamic> map) {
    return Announcement(
      id: map['id'],
      title: map['title'],
      message: map['message'],
      date: map['date'],
    );
  }
}
