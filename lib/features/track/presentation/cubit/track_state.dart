import 'package:cridr/features/home/data/models/request_model.dart';

abstract class TrackState {}

class TrackInitial extends TrackState {}

class LocationLoading extends TrackState {}

class LocationLoaded extends TrackState {}

class LocationError extends TrackState {
  final String message;
  LocationError(this.message);
}

class RequestCompleted extends TrackState {
  final RequestModel requestModel;
  RequestCompleted(this.requestModel);
}

class RequestCompleteError extends TrackState {
  final String message;
  RequestCompleteError(this.message);
}

class RequestcompleteLoaded extends TrackState {}
