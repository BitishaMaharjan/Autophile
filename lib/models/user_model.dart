class UserModel {
  final String? id;
  final String? name;
  final String email;
  final String password;
  final String? address;
  final String? photo;
  final bool? isVerified;

  const UserModel({
    this.id,
    this.name,
    required this.email,
    required this.password,
    this.address,
    this.photo,
    this.isVerified = false,
  });

  factory UserModel.fromSnapshot(Map<String, dynamic> json) {
    return UserModel(
      id: json['userId'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String,
      password: json['password'] as String,
      address: json['address'] as String?,
      photo: json['photo'] as String?,
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
      'isVerified': isVerified
    };
  }
}
