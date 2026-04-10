import 'package:cridr/features/home/data/models/request_model.dart';

abstract class TrackRepository {
  Future<Map<String, dynamic>> getProviderLocation(int reqId);
  Future<RequestModel?> completeRequest(int requestId);
}
