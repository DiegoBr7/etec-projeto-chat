import 'api.dart';

class UserService {
    Future<List<dynamic>> listarUsuarios() async {
        final response = await Api.dio.get('/api/auth/listar'); // GET certo
        return response.data;
    }

    Future<Map<String, dynamic>> criarUsuario(Map<String, dynamic> user) async {
        final response = await Api.dio.post('/api/auth/enviar', data: user); // POST certo
        return response.data;
    }

    Future<void> deletarUsuario(int id) async {
        await Api.dio.delete('/api/auth/$id'); // DELETE certo
    }

    Future<String> login(String email, String senha) async {
        final response = await Api.dio.post('/api/auth/login', data: {
            "email": email,
            "senha": senha,
        });

        return response.data; // vai retornar "Login bem-sucedido" ou erro
    }

}
