package br.com.spring.chat.websocket;

import br.com.spring.chat.dto.MessageDTO;
import br.com.spring.chat.model.Message;
import br.com.spring.chat.service.MessageService;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;

@Controller
public class ChatMessageHandler {

    private final MessageService messageService;

    public ChatMessageHandler(MessageService messageService) {
        this.messageService = messageService;
    }

    // Quando o cliente envia para /app/sendMessage
    @MessageMapping("/sendMessage")
    @SendTo("/topic/messages") // Todos conectados inscritos recebem
    public MessageDTO handleMessage(Message message) {
        // Salva no banco usando o service
        Message saved = messageService.salvarMessage(message);

        // Converte para DTO para não vazar senha etc.
        return MessageDTO.fromEntity(saved);
    }
}
