import 'package:cridr/features/home/data/models/request_model.dart';

abstract class ReqDataState {}

class ReqDataInitial extends ReqDataState {}

class ReqDataLoading extends ReqDataState {}

class ReqDataSuccess extends ReqDataState {}

class ReqDataError extends ReqDataState {}

class ReqAccepted extends ReqDataState {
  RequestModel requestModel;
  ReqAccepted({required this.requestModel});
}

class ReqAcceptedError extends ReqDataState {
  String message;
  ReqAcceptedError({required this.message});
}

class RequestCanceled extends ReqDataState {
  RequestModel requestModel;
  RequestCanceled({required this.requestModel});
}

class RequestCanceledError extends ReqDataState {
  String message;
  RequestCanceledError({required this.message});
}
