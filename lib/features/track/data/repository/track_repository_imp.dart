import 'package:cridr/features/home/data/models/request_model.dart';
import 'package:cridr/features/provider/data/data_source/get_requests.dart';
import 'package:cridr/features/provider/domain/repository/provider_repository.dart';
import 'package:cridr/features/track/data/data_source/track_remote_data_source.dart';
import 'package:cridr/features/track/domain/repository/track_repository.dart';

class TrackRepositoryImp extends TrackRepository {
  final TrackRemoteDataSource trackRemoteDataSource;

  TrackRepositoryImp({required this.trackRemoteDataSource});

  @override
  Future<Map<String, dynamic>> getProviderLocation(int reqId) =>
      trackRemoteDataSource.getProviderLocation(reqId);
@override
  Future<RequestModel?> completeRequest(int requestId) async {
    return trackRemoteDataSource.completeRequest(requestId);
  }
}
