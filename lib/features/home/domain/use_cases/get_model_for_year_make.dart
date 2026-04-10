

import 'package:cridr/features/home/data/models/model.dart';
import 'package:cridr/features/home/domain/repository/vehicle_repository.dart';

class GetModelForYearMake {
  final VehicleRepository repository;

  GetModelForYearMake(this.repository);

  Future<List<Model>> call(int year, String make) {
    return repository.getModelsForMakeYear(make, year);
  }
}
