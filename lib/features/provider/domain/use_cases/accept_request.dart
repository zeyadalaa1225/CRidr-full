import 'package:cridr/features/home/data/models/request_model.dart';
import 'package:cridr/features/provider/domain/repository/provider_repository.dart';

class AcceptRequest {
  final ProviderRepository repository;

  AcceptRequest(this.repository);

  Future<RequestModel?> call(int requestId) {
    return repository.acceptRequest(requestId);
  }
}
