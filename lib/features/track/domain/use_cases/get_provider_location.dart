import 'package:cridr/features/home/data/models/request_model.dart';
import 'package:cridr/features/track/domain/repository/track_repository.dart';

class GetProviderLocation {
  final TrackRepository repository;
  GetProviderLocation(this.repository);

  Future<Map<String, dynamic>> call(int reqId) =>
      repository.getProviderLocation(reqId);

}
