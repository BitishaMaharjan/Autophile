class UserModel {
  final String? id;
  final String? name;
  final String email;
  final String? password;
  final String? address;
  final String? photo;
  final String? bio;
  final bool? isVerified;

  const UserModel({
    this.id,
    this.name,
    required this.email,
    this.password,
    this.address,
    this.photo,
    this.bio,
    this.isVerified = false,
  });

  factory UserModel.fromSnapshot(Map<String, dynamic> json) {
    return UserModel(
      id: json['userId'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String,
      password: json['password'] as String?,
      address: json['address'] as String?,
      photo: json['photo'] as String?,
      bio: json['bio'] as String?,
      isVerified: json['isVerified'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': id,
      'name': name,
      'email': email,
      'password': password,
      'address': address,
      'photo': photo,
      'bio': bio,
      'isVerified': isVerified,
    };
  }

  factory UserModel.fromFirestore(String id, Map<String, dynamic> data) {
    return UserModel(
      id: id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      photo: data['photo'] ?? '',
      address: data['address'] ?? '',
      bio: data['bio'] ?? '',
    );
  }
}
