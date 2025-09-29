package br.com.spring.chat.service;

import br.com.spring.chat.model.Message;
import br.com.spring.chat.repository.MessageRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class MessageService {

    private final MessageRepository messageRepository;

    // Injeção via construtor (boa prática)
    public MessageService(MessageRepository messageRepository) {
        this.messageRepository = messageRepository;
    }

    public Message salvarMessage(Message message) {
        return messageRepository.save(message);
    }

    public List<Message> listarMessages() {
        return messageRepository.findAll();
    }

    public Optional<Message> buscarMessagePorId(Long id) {
        return messageRepository.findById(id);
    }

    public void deletarMessage(Long id) {
        messageRepository.deleteById(id);
    }
}
