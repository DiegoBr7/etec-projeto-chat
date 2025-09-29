import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:dio/dio.dart';
import '../services/api.dart';
import '../services/ws.dart';
import '../model/user.dart';

class ChatScreen extends StatefulWidget {
  final UserModel contact;
  const ChatScreen({super.key, required this.contact});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<types.Message> _messages = [];
  types.User? _me; // pode ser nulo até carregar
  final WSService _ws = WSService();
  int? myId;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    try {
      final res = await Api.dio.get('/users/me');
      myId = res.data['id'];
      _me = types.User(id: '$myId');

      // Conecta ao WebSocket
      _ws.connect(userId: '$myId', onMessage: (payload) {
        final incoming = types.TextMessage(
          id: '${payload['id']}',
          author: types.User(id: '${payload['senderId']}'),
          createdAt: DateTime.parse(payload['sentAt']).millisecondsSinceEpoch,
          text: payload['content'],
        );
        setState(() {
          _messages.insert(0, incoming);
        });
      });

      setState(() {}); // força rebuild depois do login
    } on DioException catch (e) {
      debugPrint("Erro ao buscar usuário logado: $e");
    }
  }

  @override
  void dispose() {
    _ws.dispose();
    super.dispose();
  }

  Future<void> _handleSend(types.PartialText m) async {
    if (_me == null) return;

    final temp = types.TextMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      author: _me!,
      text: m.text,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );

    setState(() {
      _messages.insert(0, temp);
    });

    try {
      await Api.dio.post('/messages', data: {
        'recipientId': widget.contact.id,
        'content': m.text,
      });
    } on DioException catch (e) {
      debugPrint("Erro ao enviar mensagem: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_me == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contact.displayName ?? widget.contact.username),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // volta para a tela anterior (contatos)
          },
        ),
      ),
      body: Chat(
        messages: _messages,
        onSendPressed: _handleSend,
        user: _me!, // já garantimos que não é null
      ),
    );
  }
}
