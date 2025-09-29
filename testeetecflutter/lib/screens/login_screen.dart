import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../services/api.dart';
import '../services/token_storage.dart';


class LoginScreen extends StatefulWidget { const LoginScreen({super.key});
@override State<LoginScreen> createState() => _LoginScreenState(); }


class _LoginScreenState extends State<LoginScreen> {
  final _user = TextEditingController();
  final _pass = TextEditingController();
  bool _loading = false; String? _error;


  Future<void> _login() async {
    setState(() { _loading = true; _error = null; });
    try {
      final res = await Api.dio.post('/auth/login', data: {
        'username': _user.text.trim(), 'password': _pass.text,
      });
      await TokenStorage.saveToken(res.data['token']);
      if (!mounted) return; Navigator.pushReplacementNamed(context, '/contacts');
    } on DioException catch (_) {
      setState(() { _error = 'Credenciais inválidas'; });
    } finally { if (mounted) setState(() { _loading = false; }); }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Entrar')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
          TextField(controller: _user, decoration: const InputDecoration(labelText: 'Usuário (e-mail)')),
          const SizedBox(height: 8),
          TextField(controller: _pass, decoration: const InputDecoration(labelText: 'Senha'), obscureText: true),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: _loading ? null : _login, child: Text(_loading ? 'Entrando...' : 'Acessar')),
          TextButton(onPressed: () => Navigator.pushNamed(context, '/register'), child: const Text('Não tem conta? Cadastre-se')),
        ]),
      ),
    );
  }
}