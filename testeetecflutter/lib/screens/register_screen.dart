import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../services/api.dart';
import '../services/token_storage.dart';


class RegisterScreen extends StatefulWidget { const RegisterScreen({super.key});
@override State<RegisterScreen> createState() => _RegisterScreenState(); }


class _RegisterScreenState extends State<RegisterScreen> {
  final _user = TextEditingController();
  final _name = TextEditingController();
  final _pass = TextEditingController();
  bool _loading = false; String? _error;


  Future<void> _register() async {
    setState(() { _loading = true; _error = null; });
    try {
      final res = await Api.dio.post('/auth/enviar', data: {
        "email": _user.text.trim(),
        "senha": _pass.text,
        "nome": _name.text.trim()
      });
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/contacts');
    } on DioException catch (e) {
      setState(() {
        _error = 'Erro: ${e.response?.statusCode} - ${e.response?.data}';
      });
    } finally {
      if (mounted) setState(() { _loading = false; }); }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
          TextField(controller: _user, decoration: const InputDecoration(labelText: 'Usuário (e-mail)')),
          const SizedBox(height: 8),
          TextField(controller: _name, decoration: const InputDecoration(labelText: 'Nome')),
          const SizedBox(height: 8),
          TextField(controller: _pass, decoration: const InputDecoration(labelText: 'Senha'), obscureText: true),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: _loading ? null : _register, child: Text(_loading ? 'Cadastrando...' : 'Cadastrar')),
        ]),
      ),
    );
  }
}