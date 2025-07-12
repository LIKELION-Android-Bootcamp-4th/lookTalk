import '../client/inquiry_api_client.dart';
import '../entity/inquiry_entity.dart';

class InquiryRepository {
  final InquiryApiClient apiClient;

  InquiryRepository(this.apiClient);

  Future<List<Inquiry>> getInquiries(String productId) {
    return apiClient.fetchMyInquiries(productId);
  }
}