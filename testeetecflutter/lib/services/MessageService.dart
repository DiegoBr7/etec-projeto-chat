import 'api.dart';

class MessageService {
  Future<List<dynamic>> listarMessages() async {
    final response = await Api.dio.get('/messages');
    return response.data;
  }

  Future<Map<String, dynamic>> enviarMessage(Map<String, dynamic> message) async {
    final response = await Api.dio.post('/messages', data: message);
    return response.data;
  }
}
