package br.com.spring.chat.controller;

import br.com.spring.chat.model.Message;
import br.com.spring.chat.service.MessageService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@CrossOrigin(origins = "*")
@RequestMapping("/messages")
public class MessageController {

    private final MessageService messageService;

    public MessageController(MessageService messageService) {
        this.messageService = messageService;
    }

    /**
     * 🔹 Retorna o histórico de conversa entre dois usuários específicos.
     * Exemplo de chamada:
     * GET /api/messages/chat?user1=1&user2=2
     */
    @GetMapping("/chat")
    public List<Message> listarChatEntreUsuarios(
            @RequestParam Long user1,
            @RequestParam Long user2
    ) {
        return messageService.buscarChatEntre(user1, user2);
    }

    /**
     * 🔹 Retorna todas as mensagens (admin ou debug apenas)
     */
    @GetMapping
    public List<Message> listarTodasMensagens() {
        return messageService.listarMessages();
    }

    /**
     * 🔹 Envia uma nova mensagem entre dois usuários.
     */
    @PostMapping
    public Message enviarMensagem(@RequestBody Message message) {
        return messageService.salvarMessage(message);
    }

    /**
     * 🔹 Deleta uma mensagem específica pelo ID.
     */
    @DeleteMapping("/{id}")
    public void deletarMensagem(@PathVariable Long id) {
        messageService.deletarMessage(id);
    }
}
