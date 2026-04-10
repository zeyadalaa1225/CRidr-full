import 'package:cridr/features/home/data/models/request_model.dart';
import 'package:cridr/features/provider/data/data_source/get_requests.dart';
import 'package:cridr/features/provider/domain/repository/provider_repository.dart';

class ProviderRepositoryImp extends ProviderRepository {
  final GetRequests getRequests;

  ProviderRepositoryImp({required this.getRequests});

  @override
  Future<List<RequestModel>> getPendingRequests() =>
      getRequests.getPendingRequests();
  @override
  Future<void> updateLocation(double lat, double long) =>
      getRequests.updateLocation(lat, long);
  @override
  Future<RequestModel?> acceptRequest(int requestId)=>
      getRequests.acceptRequest(requestId);
}

