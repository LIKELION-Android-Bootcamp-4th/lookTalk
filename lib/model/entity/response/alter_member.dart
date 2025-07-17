class AlterMember {
  final String email;
  final String nickName;
  final String? profileImage;

  AlterMember({required this.email, required this.nickName, required this.profileImage});

  factory AlterMember.fromJson(Map<String, dynamic> json) {
    final profile = json['profile'];
    String profileImage = '';

    if (profile is Map<String, dynamic>) {
      if (profile['profileImageUrl'] is String && profile['profileImageUrl'].toString().isNotEmpty) {
        profileImage = profile['profileImageUrl'];
      }
      else if (profile['profileImage'] is Map<String, dynamic>) {
        profileImage = (profile['profileImage'] as Map<String, dynamic>)['url'] ?? '';
      }
      else if (profile['profileImage'] is String) {
        profileImage = profile['profileImage'];
      }
    }
    return AlterMember(
        email: json['email'],
        nickName: json['nickName'],
        profileImage: profileImage,
    );
  }
}
class AlterMemberResponse{
 final AlterMember member;
 AlterMemberResponse({required this.member});

 factory AlterMemberResponse.fromJson(Map<String,dynamic> json){

   return AlterMemberResponse(
       member: AlterMember.fromJson(json['data']),
   );
 }
}