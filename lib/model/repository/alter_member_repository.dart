import 'package:dio/dio.dart';
import 'package:look_talk/core/network/end_points/mypage.dart';
import 'package:look_talk/model/entity/response/alter_member.dart';

class AlterMemberRepository {
  final Dio _dio;

  AlterMemberRepository(this._dio);

  Future<AlterMemberResponse> resultMember() async {
    try{
      final response =  await _dio.get(
        MyPage.bringMember
      );

      return AlterMemberResponse.fromJson(response.data);
    }catch(e, stack){
      print("스택 값 찾기.${stack}");
      print("값을 불러올 수 없습니다.${e}");
      throw Exception("AlterMember 불러오기 실패: $e");
    }
  }

  Future<AlterMemberResponse> alterMember(FormData formData) async {
    try{
      final response = await _dio.patch(
        MyPage.alterMember,
        data: formData,
        options: Options(
          contentType:  'multipart/form-data',
        )
      );
      return AlterMemberResponse.fromJson(response.data);
    }catch(e){
      throw Exception(e);
    }
  }

  Future<bool> checkNickname(String nickName) async{
    try{
      final response = await _dio.get(
        MyPage.checkNickname,
        queryParameters: {
          'nickname' : nickName,
        }
      );
      final isVailable = response.data['data']['available'] as bool;
      return isVailable;
    }catch(e){
      print("닉네임 중복 체크 중 오류 발생 ${e}");
      return false;
    }
  }
}
