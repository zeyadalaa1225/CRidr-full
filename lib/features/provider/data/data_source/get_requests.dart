import 'dart:async';
import 'dart:convert';

import 'package:cridr/core/socket/socket_server.dart';
import 'package:cridr/core/utils/constants/api_keys.dart';
import 'package:cridr/core/utils/local_storage/storage_utility.dart';
import 'package:cridr/features/home/data/models/request_model.dart';
import 'package:http/http.dart';

class GetRequests {
  Future<List<RequestModel>> getPendingRequests() async {
    List<RequestModel> requests = [];
    Uri uri = Uri.parse("${BASE_URL}:5000/req/PendingRequests");
    try {
      String token = await LocalStorage().readSecureData('token') ?? "";
      Response response = await get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        print(json["requests"]);
        requests = (json["requests"] as List)
            .map((e) => RequestModel.fromJson(e))
            .toList();
      } else {
        print(response.statusCode);
        Map<String, dynamic> json = jsonDecode(response.body);
        throw Exception(json["message"]);
      }
      return requests;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> updateLocation(double lat, double long) async {
    Uri uri = Uri.parse("${BASE_URL}:5000/user/change-location");
    print("aaaaalat ${lat} long ${long}");
    try {
      String token = await LocalStorage().readSecureData('token') ?? "";
      print(token);
      Response response = await put(
        uri,
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"latitude": lat, "longitude": long}),
      );
      print(response);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        Map<String, dynamic> json = jsonDecode(response.body);
        print(json["message"]);
      } else {
        print(response.statusCode);
        throw Exception("Failed to load requests");
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<RequestModel?> acceptRequest(int requestId) async {
    print("cccccccccccccc");
    try {
      String token = await LocalStorage().readSecureData('token') ?? "";
      Map<String, dynamic> data = {"requestId": requestId};

      final completer = Completer<RequestModel?>();

      // 🔹 Send socket event
      SocketServer().emit("request:accept", data);

      // 🔹 Listen for success response
      SocketServer().once("request:accept:success", (data) {
        print("✅ Request accepted: $data");

        final parsed = data is String ? jsonDecode(data) : data;
        completer.complete(RequestModel.fromJson(parsed["request"]));
      });

      // 🔹 Listen for error response
      SocketServer().once("request:accept:error", (data) {
        print("❌ Accept request failed: $data");
        completer.completeError(Exception("Failed to accept request"));
      });

      return completer.future;
    } catch (e) {
      throw Exception(e);
    }
  }
}

/// na2es aget kol el requests we a accept aw a decline we ashof 7war update el cost we en el request yegy lwa7do da
