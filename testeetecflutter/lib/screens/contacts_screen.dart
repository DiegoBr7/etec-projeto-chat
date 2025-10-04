import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../model/user.dart';
import '../services/api.dart';

class ContactsScreen extends StatefulWidget {
  final UserModel currentUser;
  const ContactsScreen({super.key, required this.currentUser});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  List<UserModel> users = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final res = await Api.dio.get('/auth/listar');
      setState(() {
        users = (res.data as List)
            .map((j) => UserModel.fromJson(j))
            .toList();
        _loading = false;
      });
    } on DioException catch (e) {
      setState(() {
        _error = 'Erro ao carregar contatos: ${e.message}';
        _loading = false;
      });
    }
  }

  void _handleBack() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      // Se não houver tela anterior, redireciona para o login
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contatos'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _handleBack,
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text(_error!, style: const TextStyle(color: Colors.red)))
          : users.isEmpty
          ? const Center(
        child: Text(
          'Nenhum contato encontrado.',
          style: TextStyle(fontSize: 16),
        ),
      )
          : ListView.separated(
        itemCount: users.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (_, i) {
          final u = users[i];
          return ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.green,
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text(u.nome),
            subtitle: Text(u.email),
            onTap: () => Navigator.pushNamed(
              context,
              '/chat',
              arguments: {'contact': u,
                'currentUser': widget.currentUser,
              },

            ),
          );
        },
      ),
    );
  }
}
