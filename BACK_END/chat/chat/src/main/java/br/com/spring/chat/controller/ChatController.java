package br.com.spring.chat.controller;

import br.com.spring.chat.model.Message;
import br.com.spring.chat.service.MessageService;
import lombok.RequiredArgsConstructor;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

@Controller
@RequiredArgsConstructor
public class ChatController {

    private final SimpMessagingTemplate messagingTemplate;
    private final MessageService messageService;

    @MessageMapping("/chat") // cliente envia para /app/chat
    public void processMessage(Message message) {
        // salvar no banco
        Message saved = messageService.salvarMessage(message);

        // enviar apenas para o destinatário
        messagingTemplate.convertAndSendToUser(
                String.valueOf(message.getReceiver().getId()),
                "/queue/messages",
                saved
        );
    }
}
