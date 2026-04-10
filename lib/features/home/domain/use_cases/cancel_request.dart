import 'package:cridr/features/home/data/models/request_model.dart';
import 'package:cridr/features/home/domain/repository/vehicle_repository.dart';

class CancelRequest {
  final VehicleRepository repository;
  CancelRequest(this.repository);

  Future<RequestModel?> call(int requestId) =>
      repository.cancelRequest(requestId);
}
