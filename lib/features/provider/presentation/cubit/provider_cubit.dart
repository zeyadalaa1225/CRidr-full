import 'dart:async';

import 'package:cridr/core/socket/socket_server.dart';
import 'package:cridr/core/utils/local_storage/storage_utility.dart';
import 'package:cridr/features/home/data/models/request_model.dart';
import 'package:cridr/features/provider/data/data_source/get_requests.dart';
import 'package:cridr/features/provider/data/repository/provider_repository_imp.dart';
import 'package:cridr/features/provider/domain/repository/provider_repository.dart';
import 'package:cridr/features/provider/presentation/cubit/provider_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:latlong2/latlong.dart';

class ProviderCubit extends Cubit<ProviderState> {
  ProviderCubit() : super(ProviderInitial());

  List<RequestModel> requests = [];
  ProviderRepository repository = ProviderRepositoryImp(
    getRequests: GetRequests(),
  );
  StreamSubscription? _newRequestSub;
  StreamSubscription? _requestAcceptedSub;
  StreamSubscription? _requestCanceledSub;
  void getRequests() async {
    emit(ProviderLoading());
    try {
      final fetched = await repository.getPendingRequests();
      requests
        ..clear()
        ..addAll(fetched);
      requests.sort((a, b) => b.cost!.compareTo(a.cost!));
      emit(ProviderLoaded(requests));
    } catch (e) {
      emit(ProviderError(e.toString()));
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
      _newRequestSub = socketServer.newRequestStream.listen((data) {
        print("✅ New request: $data");
        RequestModel request = RequestModel.fromJson(data);
        final index = request.id;
        requests.removeWhere((element) => element.id == index);
        requests.add(request);
        requests.sort((a, b) => b.cost!.compareTo(a.cost!));
        emit(ProviderLoaded(List.from(requests)));
      });
      _requestCanceledSub = socketServer.RequestCancelledStream.listen((data) {
        print("✅ request canceled: $data");
        RequestModel request = RequestModel.fromJson(data);
        final index = request.id;
        requests.removeWhere((element) => element.id == index);
        requests.sort((a, b) => b.cost!.compareTo(a.cost!));
        emit(ProviderLoaded(List.from(requests)));
      });

      /// subscribe to request accepted stream
      _requestAcceptedSub = socketServer.requestAcceptedStream.listen((
        data,
      ) async {
        print("✅ Request accepted: $data");
        RequestModel request = RequestModel.fromJson(data);
        final index = request.id;
        requests.removeWhere((element) => element.id == index);

        final providerId = request.providerId;
        // save the id when login or register and use it here to check if the request is for you or not and add states for that
        final id = await LocalStorage().readData("Id");
        if (providerId != null) {
          if (providerId == id) {
            emit(RequestAccepted(request));
          } else {
            emit(ProviderLoaded(requests));
          }
        }
        emit(ProviderLoaded(List.from(requests)));
      });
    } catch (e) {
      print("⚠️ Socket connection error: $e");
    }
  }

  void updateLocation(LatLng location) async {
    emit(update_location_loading());
    try {
      print("lat ${location.latitude} long ${location.longitude}");
      await repository.updateLocation(location.latitude, location.longitude);
      emit(update_location_success());
    } catch (e) {
      emit(update_location_error(e.toString()));
    }
  }

  void acceptRequest(int requestId) async {
    print("aaaaaaaa");
    emit(AcceptRequestLoading());
    try {
      await repository.acceptRequest(requestId);
      emit(AcceptRequestSuccess());
    } catch (e) {
      emit(AcceptRequestError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _newRequestSub?.cancel();
    return super.close();
  }
}
