// lib/model/entity/response/profile.dart

class Profile {
  final String name;
  final String profileImage;
  final String birthDate;

  Profile({
    required this.name,
    required this.profileImage,
    required this.birthDate,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      name: json['name'] as String,
      profileImage: json['profileImage'] as String,
      birthDate: json['birthDate'] as String,
    );
  }
}
