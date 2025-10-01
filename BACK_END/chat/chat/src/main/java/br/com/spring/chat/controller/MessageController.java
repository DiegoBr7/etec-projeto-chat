package br.com.spring.chat.controller;

import br.com.spring.chat.model.Message;
import br.com.spring.chat.service.MessageService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@CrossOrigin(origins = "*")
@RequestMapping("/messages") // plural e RESTful
public class MessageController {

    private final MessageService messageService;

    // injeção via construtor
    public MessageController(MessageService messageService) {
        this.messageService = messageService;
    }

    @GetMapping
    public List<Message> listarMessages() {
        return messageService.listarMessages();
    }

    @PostMapping
    public Message enviarMessage(@RequestBody Message message) {
        return messageService.salvarMessage(message);
    }

    @DeleteMapping("/{id}")
    public void deletarMessage(@PathVariable Long id) {
        messageService.deletarMessage(id);
    }
}