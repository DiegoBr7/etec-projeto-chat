import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/contacts_screen.dart';
import 'screens/chat_screen.dart';

void main() {
  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Flutter',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.green),
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
      },
      onGenerateRoute: (settings) {
        // 🔹 Tela de contatos (recebe o usuário logado)
        if (settings.name == '/contacts') {
          final args =
          settings.arguments as Map<String, dynamic>; // recebe o user do login
          return MaterialPageRoute(
            builder: (_) => ContactsScreen(
              currentUser: args['currentUser'],
            ),
          );
        }

        // 🔹 Tela de chat (recebe o contato e o usuário logado)
        if (settings.name == '/chat') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (_) => ChatScreen(
              contact: args['contact'],
              currentUser: args['currentUser'],
            ),
          );
        }

        return null;
      },
    );
  }
}
