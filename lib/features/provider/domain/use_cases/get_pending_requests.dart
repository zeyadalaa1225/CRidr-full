import 'package:cridr/features/home/data/models/request_model.dart';
import 'package:cridr/features/provider/domain/repository/provider_repository.dart';

class GetPendingRequests {
  final ProviderRepository repository;

  GetPendingRequests(this.repository);

  Future<List<RequestModel>> call() {
    return repository.getPendingRequests();
  }

  
}
