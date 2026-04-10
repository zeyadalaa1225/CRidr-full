import 'dart:async';
import 'dart:convert';

import 'package:cridr/core/utils/constants/api_keys.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketServer {
  static final SocketServer _instance = SocketServer._internal();
  factory SocketServer() => _instance;
  SocketServer._internal();

  IO.Socket? socket;
  final StreamController<dynamic> _newRequestController =
      StreamController<dynamic>.broadcast();
  final StreamController<dynamic> _requestAcceptedController =
      StreamController<dynamic>.broadcast();
  final StreamController<dynamic> _requestCompleteController =
      StreamController<dynamic>.broadcast();
  final StreamController<dynamic> _requestCancelledController =
      StreamController<dynamic>.broadcast();
  Stream<dynamic> get newRequestStream => _newRequestController.stream;
  Stream<dynamic> get requestAcceptedStream =>
      _requestAcceptedController.stream;
  Stream<dynamic> get RequestCompleteStream =>
      _requestCompleteController.stream;
  Stream<dynamic> get RequestCancelledStream =>
      _requestCancelledController.stream;
  void connect(String token) {
    if (socket != null && socket!.connected) {
      print("⚠️ Socket already connected");
      return;
    }

    print("token: $token");
    socket = IO.io(
      "$BASE_URL:5000", // must match backend
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({"token": token})
          .disableAutoConnect()
          .build(),
    );

    socket!.connect();

    socket!.onConnect((_) {
      print("✅ Connected: ${socket!.id}");
    });

    socket!.onConnectError((err) {
      print("⚠️ Connect error: $err");
    });

    socket!.onDisconnect((_) {
      print("❌ Disconnected");
    });

    socket!.onError((err) {
      print("⚠️ Socket error: $err");
    });

    socket!.on("request:success", (data) {
      print("📥 request:success => $data");
      try {
        data = data is String ? jsonDecode(data) : data;

        if (data is Map && data.containsKey("request")) {
          _newRequestController.add(data["request"]);
        } else {
          print("⚠️ No 'request' key in data: $data");
        }
      } catch (e) {
        print("⚠️ Error parsing request:success $e");
      }
    });

    socket!.on("request:update", (data) {
      print("📥 request:update => $data");
      try {
        data = data is String ? jsonDecode(data) : data;

        if (data is Map && data.containsKey("request")) {
          _newRequestController.add(data["request"]);
        } else {
          print("⚠️ No 'request' key in data: $data");
        }
      } catch (e) {
        print("⚠️ Error parsing request:update $e");
      }
    });
    socket!.on("request:accept:success", (data) {
      print("📥 request:accepted:success => $data");
      try {
        data = data is String ? jsonDecode(data) : data;

        if (data is Map && data.containsKey("request")) {
          _requestAcceptedController.add(data["request"]);
        } else {
          print("⚠️ No 'request' key in data: $data");
        }
      } catch (e) {
        print("⚠️ Error parsing request:accepted:success $e");
      }
    });
    socket!.on("request:complete:success", (data) {
      print("📥 request:complete:success => $data");
      try {
        data = data is String ? jsonDecode(data) : data;

        if (data is Map && data.containsKey("request")) {
          _requestCompleteController.add(data["request"]);
        } else {
          print("⚠️ No 'request' key in data: $data");
        }
      } catch (e) {
        print("⚠️ Error parsing request:accepted:success $e");
      }
    });
    socket!.on("request:cancel:success", (data) {
      print("📥 request:cancel:success => $data");
      try {
        data = data is String ? jsonDecode(data) : data;

        if (data is Map && data.containsKey("request")) {
          _requestCancelledController.add(data["request"]);
        } else {
          print("⚠️ No 'request' key in data: $data");
        }
      } catch (e) {
        print("⚠️ Error parsing request:Cancel:success $e");
      }
    });
  }

  void on(String event, Function(dynamic) handler) {
    socket?.on(event, handler);
  }

  void once(String event, Function(dynamic) handler) {
    socket?.once(event, handler);
  }

  void emit(String event, dynamic data) {
    if (socket != null && socket!.connected) {
      socket!.emit(event, data);
      print("📤 Emitted '$event': $data");
    } else {
      print("❌ Cannot emit, socket not connected");
    }
  }

  void off(String event) {
    socket?.off(event);
  }

  void disconnect() {
    socket?.disconnect();
    socket = null;
  }
}
