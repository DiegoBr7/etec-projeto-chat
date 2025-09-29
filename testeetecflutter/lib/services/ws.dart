// services/ws.dart
import 'dart:convert';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'api.dart';

class WSService {
  StompClient? _client;

  void connect({
    required String userId,
    required void Function(Map<String, dynamic>) onMessage,
  }) {
    _client = StompClient(
      config: StompConfig(
        url: Api.base.replaceFirst('http', 'ws') + '/ws/websocket',
        onConnect: (StompFrame frame) {
          _client?.subscribe(
            destination: '/user/$userId/queue/messages',
            callback: (frame) {
              if (frame.body != null) {
                onMessage(json.decode(frame.body!));
              }
            },
          );
        },
        onWebSocketError: (e) => print('Erro WS: $e'),
        reconnectDelay: const Duration(seconds: 5),
        heartbeatIncoming: const Duration(seconds: 4),
        heartbeatOutgoing: const Duration(seconds: 4),
      ),
    );

    _client?.activate();
  }

  void dispose() {
    _client?.deactivate();
  }
}
