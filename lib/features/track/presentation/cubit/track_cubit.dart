import 'dart:async';

import 'package:cridr/core/socket/socket_server.dart';
import 'package:cridr/core/utils/local_storage/storage_utility.dart';
import 'package:cridr/features/home/data/models/request_model.dart';
import 'package:cridr/features/track/data/data_source/track_remote_data_source.dart';
import 'package:cridr/features/track/data/repository/track_repository_imp.dart';
import 'package:cridr/features/track/domain/repository/track_repository.dart';
import 'package:cridr/features/track/presentation/cubit/track_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TrackCubit extends Cubit<TrackState> {
  TrackCubit() : super(TrackInitial());
  double lat = 0.0;
  double long = 0.0;
  TrackRemoteDataSource trackRemoteDataSource = TrackRemoteDataSource();
  TrackRepository trackRepository = TrackRepositoryImp(
    trackRemoteDataSource: TrackRemoteDataSource(),
  );
  StreamSubscription? _requestCompleteedSub;
  void getLocation(int reqId) async {
    try {
      emit(LocationLoading());
      final location = await trackRepository.getProviderLocation(reqId);
      lat = location["latitude"];
      long = location["longitude"];
      emit(LocationLoaded());
    } catch (e) {
      emit(LocationError(e.toString()));
    }
  }

  Future<void> connectToSocket() async {

    try {
      final token = await LocalStorage().readSecureData("token");
      if (token == null) {
        print("❌ No token found in storage");
        return;
      }

      final socketServer = SocketServer();
      socketServer.connect(token);
      print("aaaaaaaa");

      /// subscribe to new requests stream
      _requestCompleteedSub = socketServer.RequestCompleteStream.listen((data) {
        print("✅ New request: $data");
        RequestModel request = RequestModel.fromJson(data);

        emit(RequestCompleted(request));
      });
    } catch (e) {
      print("⚠️ Socket connection error: $e");
      emit(RequestCompleteError(e.toString()));
    }
  }
  Future<void>completeRequest(int requestId)async{
    try{
      await trackRepository.completeRequest(requestId);
    }catch(e){
      emit(RequestCompleteError(e.toString()));
    }
  }
}
