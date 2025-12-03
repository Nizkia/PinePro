class Entrepreneur {
  final int? id;
  final int userId;
  final String name;
  final String businessType;
  final String location;
  final String phone;
  final String? telegram;
  final String? website;
  final String? imageUrl;
  final String? description;

  Entrepreneur({
    this.id,
    required this.userId,       // <-- required
    required this.name,
    required this.businessType,
    required this.location,
    required this.phone,
    this.telegram,
    this.website,
    this.imageUrl,
    this.description,
  });

  factory Entrepreneur.fromMap(Map<String, dynamic> map) {
    return Entrepreneur(
      id: map['id'],
      userId: map['userId'],
      name: map['name'],
      businessType: map['businessType'],
      location: map['location'],
      phone: map['phone'],
      telegram: map['telegram'],
      website: map['website'],
      imageUrl: map['imageUrl'],
      description: map['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'businessType': businessType,
      'location': location,
      'phone': phone,
      'telegram': telegram,
      'website': website,
      'imageUrl': imageUrl,
      'description': description,
    };
  }
}
