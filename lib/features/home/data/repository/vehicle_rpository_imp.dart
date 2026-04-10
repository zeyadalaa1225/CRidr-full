import 'package:cridr/features/home/data/data_sources/vehicle_remote_data_source.dart';
import 'package:cridr/features/home/data/models/make.dart';
import 'package:cridr/features/home/data/models/model.dart';
import 'package:cridr/features/home/data/models/req_data.dart';
import 'package:cridr/features/home/data/models/request_model.dart';
import 'package:cridr/features/home/domain/repository/vehicle_repository.dart';

class VehicleRpositoryImp extends VehicleRepository {
  final VehicleRemoteDataSource remoteDataSource;

  VehicleRpositoryImp(this.remoteDataSource);

  @override
  Future<List<Make>> getMakesForYear(int year) {
    return remoteDataSource.getMakesForYear(year);
  }

  @override
  Future<List<Model>> getModelsForMakeYear(String make, int year) {
    return remoteDataSource.getModelsForMakeYear(make, year);
  }

  @override
  Future<RequestModel?> createServiceRequest(ReqData reqData) {
    return remoteDataSource.createServiceRequest(reqData);
  }

  @override
  Future<RequestModel?> updatePrice(int requestId, int newPrice) {
    return remoteDataSource.updatePrice(requestId, newPrice);
  }

  @override
  Future<RequestModel?> cancelRequest(int requestId) {
    return remoteDataSource.cancelRequest(requestId);
  }
}
