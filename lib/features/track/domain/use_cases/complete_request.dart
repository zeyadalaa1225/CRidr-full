import 'package:cridr/features/home/data/models/request_model.dart';
import 'package:cridr/features/track/domain/repository/track_repository.dart';

class CompleteRequest {
  final TrackRepository trackRepository;
  CompleteRequest(this.trackRepository);

  Future<RequestModel?> call(int requestId) => trackRepository.completeRequest(requestId);
}