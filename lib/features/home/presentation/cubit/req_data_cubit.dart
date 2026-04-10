import 'dart:async';

import 'package:cridr/core/socket/socket_server.dart';
import 'package:cridr/core/utils/local_storage/storage_utility.dart';
import 'package:cridr/features/home/data/data_sources/vehicle_remote_data_source.dart';
import 'package:cridr/features/home/data/models/req_data.dart';
import 'package:cridr/features/home/data/models/request_model.dart';
import 'package:cridr/features/home/data/repository/vehicle_rpository_imp.dart';
import 'package:cridr/features/home/domain/repository/vehicle_repository.dart';
import 'package:cridr/features/home/presentation/cubit/req_data_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

class ReqDataCubit extends Cubit<ReqDataState> {
  ReqDataCubit() : super(ReqDataInitial());
  ReqData reqData = ReqData();
  RequestModel? requestModel;
  VehicleRepository repository = VehicleRpositoryImp(VehicleRemoteDataSource());
  StreamSubscription? _newRequestSub;
  StreamSubscription? _requestCanceledSub;
  void updatereqesttype(String type) {
    reqData.reqtype = type;
    emit(ReqDataSuccess());
  }

  void updatalocation(LatLng latlng) {
    reqData.location = latlng;
    emit(ReqDataSuccess());
  }

  void updatevehicleinfo(
    int year,
    String make,
    String model,
    String color,
  ) async {
    reqData.year = year;
    reqData.make = make;
    reqData.model = model;
    reqData.color = color;

    try {
      requestModel = await repository.createServiceRequest(reqData);
      emit(ReqDataSuccess());
    } catch (error) {
      print("Error creating service request: $error");
      emit(ReqDataError());
    }
  }

  void updateprice(int newPrice) async {
    emit(ReqDataLoading());
    try {
      requestModel = await repository.updatePrice(requestModel!.id, newPrice);
      emit(ReqDataSuccess());
    } catch (error) {
      print("Error updating price: $error");
      emit(ReqDataError());
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
      _newRequestSub = socketServer.requestAcceptedStream.listen((data) {
        print("✅ New request: $data");
        RequestModel request = RequestModel.fromJson(data);
        emit(ReqAccepted(requestModel: request));
      });
      _requestCanceledSub = socketServer.RequestCancelledStream.listen((data) {
        print("✅ request canceled: $data");
        RequestModel request = RequestModel.fromJson(data);
        print("aaaaaaaaaaaaaaaaa");
        emit(RequestCanceled(requestModel: request));
      });
    } catch (e) {
      print("⚠️ Socket connection error: $e");
      emit(ReqAcceptedError(message: e.toString()));
    }
  }

  Future<void> cancelRequest() async {
    try {
      await repository.cancelRequest(requestModel!.id);
    } catch (e) {
      emit(RequestCanceledError(message: e.toString()));
    }
  }
}
