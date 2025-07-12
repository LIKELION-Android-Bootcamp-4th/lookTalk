import '../../core/network/api_result.dart';
import '../client/nickname_api_client.dart';
import '../entity/request/nickname_request.dart';
import '../entity/response/nickname_check_response.dart';

// // api client 를 사용해 받은 응답 반환
// class NicknameRepository {
//   final NicknameApiClient apiClient;
//
//   NicknameRepository(this.apiClient);
//
//   Future<ApiResult<NicknameCheckResponse>> checkNickname(NicknameCheckRequest request,) {
//     return apiClient.checkNicknameAvailable(request);
//   }
// }

class CheckNameRepository{
  final CheckNameApiClient apiClient;

  CheckNameRepository(this.apiClient);

  Future<ApiResult<CheckNameResponse>> check(CheckNameRequest request){
    return apiClient.checkDuplicate(request);
  }
}