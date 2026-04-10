

import 'package:cridr/features/home/data/models/make.dart';
import 'package:cridr/features/home/data/models/model.dart';
import 'package:cridr/features/home/data/models/req_data.dart';
import 'package:cridr/features/home/data/models/request_model.dart';

abstract class VehicleRepository {
  Future<List<Make>> getMakesForYear(int year);
  Future<List<Model>> getModelsForMakeYear(String make, int year);
  Future<RequestModel?> createServiceRequest(ReqData reqData);
  Future<RequestModel?> updatePrice(int requestId, int newPrice);
  Future<RequestModel?> cancelRequest(int requestId);
}
