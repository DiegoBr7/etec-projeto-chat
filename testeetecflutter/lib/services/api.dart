import 'package:dio/dio.dart';
import 'token_storage.dart';


class Api {
  static const String base = 'http://10.0.2.2:8080'; // Emulador Android
  static final Dio dio = Dio(BaseOptions(baseUrl: base));
    // ..interceptors.add(InterceptorsWrapper(onRequest: (options, handler) async {
    //   final token = await TokenStorage.getToken();
    //   if (token != null) {
    //     options.headers['Authorization'] = 'Bearer $token';
    //   }
    //   return handler.next(options);
    // }));



  //static Dio get dio => _dio;
}