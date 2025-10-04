import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../model/user.dart';
import '../services/api.dart';
import '../services/token_storage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _user = TextEditingController();
  final _pass = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _login() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      // 🔹 Requisição de login
      final res = await Api.dio.post('/auth/login', data: {
        'email': _user.text.trim(),
        'senha': _pass.text,
      });

      if (res.statusCode == 200 && res.data != null) {
        // 🔹 Agora busca o usuário pelo e-mail (para ter o ID e nome)
        final userRes = await Api.dio.get(
          '/auth/findByEmail',
          queryParameters: {'email': _user.text.trim()},
        );

        final userData = userRes.data;

        // Cria o modelo do usuário logado
        final currentUser = UserModel(
          id: userData['id'],
          nome: userData['nome'],
          email: userData['email'], senha: '',
        );

        // 🔹 Redireciona para a tela de contatos com o usuário atual
        if (!mounted) return;
        Navigator.pushReplacementNamed(
          context,
          '/contacts',
          arguments: {'currentUser': currentUser},
        );
      } else {
        setState(() {
          _error = 'Falha no login. Tente novamente.';
        });
      }
    } on DioException catch (e) {
      setState(() {
        _error = 'Credenciais inválidas';
      });
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Entrar')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            TextField(
              controller: _user,
              decoration:
              const InputDecoration(labelText: 'Usuário (e-mail)'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _pass,
              decoration: const InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading ? null : _login,
              child: Text(_loading ? 'Entrando...' : 'Acessar'),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/register'),
              child: const Text('Não tem conta? Cadastre-se'),
            ),
          ],
        ),
      ),
    );
  }
}
