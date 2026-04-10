// import 'package:cridr/core/network/api_endpoints.dart';
// import 'package:dio/dio.dart';
// import 'package:cridr/core/utils/local_storage/storage_utility.dart';

// const _kTokenKey = 'auth_token';

// class ApiService {
//   final Dio dio;
//   final LocalStorage storage;

//   ApiService(this.dio, this.storage) {
//     dio.options = BaseOptions(
//       baseUrl: ApiEndpoints.baseUrl,
//       connectTimeout: const Duration(seconds: 15),
//       receiveTimeout: const Duration(seconds: 15),
//       headers: {'Content-Type': 'application/json'},
//     );

//     dio.interceptors.add(
//       InterceptorsWrapper(onRequest: (options, handler) async {
//         final token = await storage.readSecureData(_kTokenKey);
//         if (token != null && token.isNotEmpty) {
//           options.headers['Authorization'] = 'Bearer $token';
//         }
//         handler.next(options);
//       }),
//     );

//     dio.interceptors.add(LogInterceptor(
//       requestHeader: true,
//       requestBody: true,
//       responseBody: true,
//     ));
//   }
// }
