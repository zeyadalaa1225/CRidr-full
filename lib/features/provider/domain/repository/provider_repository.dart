import 'package:cridr/features/home/data/models/request_model.dart';

abstract class ProviderRepository {
  Future<List<RequestModel>> getPendingRequests();
  Future<void> updateLocation(double lat, double long);
  Future<RequestModel?> acceptRequest(int requestId);
}
