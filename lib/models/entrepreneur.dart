class Entrepreneur {
  int? id;
  String name;
  String businessType;
  String location;
  String phone;

  // NEW FIELDS
  String? telegram;    // social media
  String? website;     // website / online shop
  String? imageUrl;    // profile/product image URL
  String? description; // short bio / business description

  Entrepreneur({
    this.id,
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
