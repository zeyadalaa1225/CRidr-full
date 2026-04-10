import 'package:cridr/features/home/data/models/request_model.dart';
import 'package:cridr/features/home/domain/repository/vehicle_repository.dart';

class RequestUpdate {
  final VehicleRepository repository;
  RequestUpdate(this.repository);

  Future<RequestModel?> call(int requestId, int newPrice) {
    return repository.updatePrice(requestId, newPrice);
  }
}
