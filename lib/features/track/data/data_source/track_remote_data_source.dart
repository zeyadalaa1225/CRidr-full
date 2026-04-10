import 'dart:async';
import 'dart:convert';
import 'package:cridr/core/socket/socket_server.dart';
import 'package:cridr/core/utils/constants/api_keys.dart';
import 'package:cridr/core/utils/local_storage/storage_utility.dart';
import 'package:cridr/features/home/data/models/request_model.dart';
import 'package:http/http.dart';

class TrackRemoteDataSource {
  Future<Map<String, dynamic>> getProviderLocation(int reqId) async {
    final uri = Uri.parse("$BASE_URL:5000/user/provider-location/$reqId");
    try {
      final token = await LocalStorage().readSecureData('token') ?? "";
      final response = await get(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        final json = jsonDecode(response.body);
        throw Exception(json["message"]);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<RequestModel?> completeRequest(int requestId) async {
    try {
      String token = await LocalStorage().readSecureData('token') ?? "";
      Map<String, dynamic> data = {"requestId": requestId};
      final completer = Completer<RequestModel?>();
      SocketServer().emit("request:complete", data);
      SocketServer().once("request:complete", (data) {
        print("✅ Request update success: $data");

        final parsed = data is String ? jsonDecode(data) : data;
        completer.complete(RequestModel.fromJson(parsed["request"]));
      });

      SocketServer().once("request:complete:error", (data) {
        print("❌ Request failed: $data");
        completer.completeError(
          Exception("Failed to complete service request"),
        );
      });

      return completer.future;
    } catch (e) {
      throw Exception(e);
    }
  }
}
