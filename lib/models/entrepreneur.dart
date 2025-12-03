class Entrepreneur {
  int? id;
  String name;
  String phone;
  String location;
  String businessType;

  Entrepreneur({
    this.id,
    required this.name,
    required this.phone,
    required this.location,
    required this.businessType,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'location': location,
      'businessType': businessType,
    };
  }

  factory Entrepreneur.fromMap(Map<String, dynamic> map) {
    return Entrepreneur(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      location: map['location'],
      businessType: map['businessType'],
    );
  }
}
