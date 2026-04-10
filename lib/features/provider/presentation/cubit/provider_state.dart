import 'package:cridr/features/home/data/models/request_model.dart';

abstract class ProviderState {
  
}

class ProviderInitial extends ProviderState {
 
}

class ProviderLoading extends ProviderState {
  
}

class ProviderLoaded extends ProviderState {
  List<RequestModel> requests;
  ProviderLoaded(this.requests);
}

class ProviderError extends ProviderState {
  final String message;
  ProviderError(this.message);
}

class update_location_success extends ProviderState {}

class update_location_error extends ProviderState {
  final String errorMessage;
  update_location_error(this.errorMessage);
}

class update_location_loading extends ProviderState {}

class RequestTaken extends ProviderState {}

class RequestAccepted extends ProviderState {
  final RequestModel request;
  RequestAccepted(this.request);
}

class AcceptRequestLoading extends ProviderState {}

class AcceptRequestSuccess extends ProviderState {}

class AcceptRequestError extends ProviderState {
  final String errorMessage;
  AcceptRequestError(this.errorMessage);
}
