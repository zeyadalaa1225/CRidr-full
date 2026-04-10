import 'package:cridr/features/home/data/models/req_data.dart';
import 'package:cridr/features/home/data/models/request_model.dart';
import 'package:cridr/features/home/domain/repository/vehicle_repository.dart';

class CreateServiceRequest {
  final VehicleRepository vehicleRepository;
  CreateServiceRequest(this.vehicleRepository);

  Future<RequestModel?> call(ReqData reqData) {
    return vehicleRepository.createServiceRequest(reqData);
  }
}
