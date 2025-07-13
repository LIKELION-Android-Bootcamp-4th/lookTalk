import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:look_talk/model/entity/response/alter_member.dart';
import 'package:look_talk/model/repository/alter_member_repository.dart';

class AlterMemberViewmodel with ChangeNotifier{
  final AlterMemberRepository repository;

  AlterMemberResponse? _alterMember;
  AlterMemberResponse? get alterMember => _alterMember;

  AlterMemberViewmodel({required this.repository}){
    _init();
  }

  void _init() async{
    _alterMember = await repository.resultMember();
    notifyListeners();
}
  Future<void> fetchLatestMember() async {
    _alterMember = await repository.resultMember();
    notifyListeners();
  }
Future<void> updateMemberFetch(String nickName, String? profileImage) async{
    try {
      final FormData formData = FormData.fromMap({
        'nickName' : nickName,
        if(profileImage != null && profileImage.isNotEmpty)
          'profileImage' : await MultipartFile.fromFile(profileImage),
      });
      _alterMember = await repository.alterMember(formData);
    }catch(e){
      print("수정이 되지 않습니다.${e}");
    }
    notifyListeners();
}

Future<bool> checkNickname(String nickName) async{
    try{
      final result = await repository.checkNickname(nickName);
      return result;
    }catch(e){
      print("중복 체크 중 안됨 : ${e}");
      return false;
    }
}

}