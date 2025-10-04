import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:dio/dio.dart';
import '../services/api.dart';
import '../services/ws.dart';
import '../model/user.dart';

class ChatScreen extends StatefulWidget {
  final UserModel contact;
  final UserModel currentUser; // 👈 Adicionado

  const ChatScreen({
    super.key,
    required this.contact,
    required this.currentUser,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<types.Message> _messages = [];
  final WSService _ws = WSService();
  types.User? _me;
  int? myId;

  @override
  void initState() {
    super.initState();
    _loadChat();
  }

  Future<void> _loadChat() async {
    try {
      // ✅ Usa o ID do usuário logado
      myId = widget.currentUser.id;
      _me = types.User(id: '$myId');

      // 🔹 Busca histórico APENAS entre os dois usuários
      final history = await Api.dio.get(
        '/messages/chat',
        queryParameters: {
          'user1': myId,
          'user2': widget.contact.id,
        },
      );

      final msgs = (history.data as List).map((m) {
        return types.TextMessage(
          id: '${m['id']}',
          author: types.User(id: '${m['sender']['id']}'),
          text: m['content'],
          createdAt:
          DateTime.parse(m['createdAt']).millisecondsSinceEpoch,
        );
      }).toList();

      setState(() {
        _messages
          ..clear()
          ..addAll(msgs.reversed);
      });

      // 🔹 Conecta o WebSocket apenas do logado
      _ws.connect(userId: '$myId', onMessage: (payload) {
        final senderId = payload['sender']['id'];
        final receiverId = payload['receiver']['id'];

        // Exibir só mensagens entre logado e contato atual
        if ((senderId == widget.contact.id && receiverId == myId) ||
            (senderId == myId && receiverId == widget.contact.id)) {
          final incoming = types.TextMessage(
            id: '${payload['id']}',
            author: types.User(id: '$senderId'),
            text: payload['content'],
            createdAt: DateTime.parse(payload['createdAt'])
                .millisecondsSinceEpoch,
          );
          setState(() {
            _messages.insert(0, incoming);
          });
        }
      });
    } on DioException catch (e) {
      debugPrint(
          '❌ Erro ao carregar chat: ${e.response?.statusCode} ${e.response?.data}');
    }
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
      // 🔹 Envia mensagem ao backend
      await Api.dio.post('/messages', data: {
        'content': m.text,
        'sender': {'id': myId},
        'receiver': {'id': widget.contact.id},
      });

      // 🔹 Também envia via WebSocket
      _ws.sendMessage({
        'content': m.text,
        'sender': {'id': myId},
        'receiver': {'id': widget.contact.id},
      });
    } on DioException catch (e) {
      debugPrint("❌ Erro ao enviar mensagem: ${e.response?.statusCode}");
    }
  }

  @override
  void dispose() {
    _ws.dispose();
    super.dispose();
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
        title: Text(widget.contact.nome),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Chat(
        messages: _messages,
        onSendPressed: _handleSend,
        user: _me!,
      ),
    );
  }
}
