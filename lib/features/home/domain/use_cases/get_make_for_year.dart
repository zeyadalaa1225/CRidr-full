
import 'package:cridr/features/home/data/models/make.dart';
import 'package:cridr/features/home/domain/repository/vehicle_repository.dart';

class GetMakesForYear {
  final VehicleRepository repository;

  GetMakesForYear(this.repository);

  Future<List<Make>> call(int year) {
    return repository.getMakesForYear(year);
  }
}
