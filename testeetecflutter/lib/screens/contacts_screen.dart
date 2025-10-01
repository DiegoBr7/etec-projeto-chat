import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../model/user.dart';
import '../services/api.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  List<UserModel> users = [];

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
      });
    } on DioException catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contatos'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // volta para a tela anterior
          },
        ),
      ),
      body: ListView.separated(
        itemCount: users.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (_, i) {
          final u = users[i];
          return ListTile(
            title: Text(u.nome),
            subtitle: Text(u.email),
            onTap: () => Navigator.pushNamed(
              context,
              '/chat',
              arguments: {'contact': u},
            ),
          );
        },
      ),
    );
  }
}
