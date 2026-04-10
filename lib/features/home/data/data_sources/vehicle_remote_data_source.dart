import 'dart:async';
import 'dart:convert';

import 'package:cridr/core/socket/socket_server.dart';
import 'package:cridr/core/utils/constants/api_keys.dart';
import 'package:cridr/core/utils/local_storage/storage_utility.dart';
import 'package:cridr/features/home/data/models/make.dart';
import 'package:cridr/features/home/data/models/model.dart';
import 'package:cridr/features/home/data/models/req_data.dart';
import 'package:cridr/features/home/data/models/request_model.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart';

class VehicleRemoteDataSource {
  Future<List<Make>> getMakesForYear(int year) async {
    String apiKey = X_RAPIDAPI_KEY;
    List<Make> makes = [];
    Uri uri = Uri.parse("https://car-api2.p.rapidapi.com/api/makes?year=$year");
    try {
      Response response = await get(uri, headers: {"X-RapidAPI-Key": apiKey});
      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        print(json["data"]);
        makes = (json["data"] as List).map((e) => Make.fromJson(e)).toList();
      } else {
        throw Exception("Failed to load makes");
      }
    } catch (e) {
      throw Exception(e);
    }
    return makes;
  }

  Future<List<Model>> getModelsForMakeYear(String make, int year) async {
    List<Model> models = [];
    Uri uri = Uri.parse(
      "https://vpic.nhtsa.dot.gov/api/vehicles/GetModelsForMakeYear/make/$make/modelyear/$year?format=json",
    );
    try {
      Response response = await get(uri);
      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        models = (json["Results"] as List)
            .map((e) => Model.fromJson(e))
            .toList();
      } else {
        throw Exception("Failed to load models");
      }
    } catch (e) {
      throw Exception(e);
    }
    return models;
  }

  Future<RequestModel?> createServiceRequest(ReqData reqData) async {
    Uri uri = Uri.parse("${BASE_URL}:5000/req/request");
    try {
      Map<String, dynamic> posteddata = {
        'issueType': reqData.reqtype,
        'carYear': reqData.year,
        'carMake': reqData.make,
        'carModel': reqData.model,
        'carColor': reqData.color,
        'latitude': reqData.location?.latitude,
        'longitude': reqData.location?.longitude,
        'notes': "ay habd",
      };

      String token = await LocalStorage().readSecureData('token') ?? "";
      print(" token $token");
      print(jsonEncode(posteddata));

      final completer = Completer<RequestModel?>();

      SocketServer().emit("request", posteddata);

      SocketServer().on("request:success", (data) {
        print("✅ Request success: $data");
        // if backend already sends a Map, don't decode again
        final parsed = data is String ? jsonDecode(data) : data;
        completer.complete(RequestModel.fromJson(parsed["request"]));
      });

      SocketServer().on("request:error", (data) {
        print("❌ Request failed: $data");
        completer.completeError(Exception("Failed to create service request"));
      });

      return completer.future;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<RequestModel?> updatePrice(int requestId, int newPrice) async {
    try {
      String token = await LocalStorage().readSecureData('token') ?? "";
      Map<String, dynamic> data = {"requestId": requestId, "price": newPrice};
      final completer = Completer<RequestModel?>();
      SocketServer().emit("request:price", data);
      SocketServer().once("request:update", (data) {
        print("✅ Request update success: $data");

        final parsed = data is String ? jsonDecode(data) : data;
        completer.complete(RequestModel.fromJson(parsed["request"]));
      });

      SocketServer().once("request:update:error", (data) {
        print("❌ Request failed: $data");
        completer.completeError(Exception("Failed to create service request"));
      });

      return completer.future;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<RequestModel?> cancelRequest(int requestId) async {
    try {
      String token = await LocalStorage().readSecureData('token') ?? "";
      Map<String, dynamic> data = {"requestId": requestId};
      final completer = Completer<RequestModel?>();
      SocketServer().emit("request:cancel", data);
      SocketServer().once("request:cancel:success", (data) {
        print("✅ Request cancel success: $data");

        final parsed = data is String ? jsonDecode(data) : data;
        completer.complete(RequestModel.fromJson(parsed["request"]));
      });

      SocketServer().once("request:cancel:error", (data) {
        print("❌ Request failed: $data");
        completer.completeError(Exception("Failed to cancel service request"));
      });

      return completer.future;
    } catch (e) {
      throw Exception(e);
    }
  }
}
