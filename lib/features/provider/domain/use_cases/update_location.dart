import 'package:cridr/features/provider/domain/repository/provider_repository.dart';

class UpdateLocation {
  final ProviderRepository repository;

  UpdateLocation(this.repository);

  Future<void> call(double lat, double long) {
    return repository.updateLocation(lat, long);
  }
}
