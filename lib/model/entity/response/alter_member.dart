class AlterMember {
  final String email;
  final String nickName;
  final String? profileImage;

  AlterMember({required this.email, required this.nickName, required this.profileImage});

  factory AlterMember.fromJson(Map<String, dynamic> json) {
    return AlterMember(
        email: json['email'],
        nickName: json['nickName'],
        profileImage: json['profile']?['name'] as String?,
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