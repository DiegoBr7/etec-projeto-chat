package br.com.spring.chat.service;

import br.com.spring.chat.model.Message;
import br.com.spring.chat.repository.MessageRepository;
import br.com.spring.chat.repository.UserRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class MessageService {

    private final MessageRepository messageRepository;
    private final UserRepository userRepository;

    public MessageService(MessageRepository messageRepository, UserRepository userRepository) {
        this.messageRepository = messageRepository;
        this.userRepository = userRepository;
    }

    public Message salvarMessage(Message message) {
        // Busca os usuários completos no banco
        var sender = userRepository.findById(message.getSender().getId())
                .orElseThrow(() -> new RuntimeException("Sender não encontrado"));

        var receiver = userRepository.findById(message.getReceiver().getId())
                .orElseThrow(() -> new RuntimeException("Receiver não encontrado"));

        // Substitui os objetos parciais pelos completos
        message.setSender(sender);
        message.setReceiver(receiver);

        return messageRepository.save(message);
    }

    public List<Message> listarMessages() {
        return messageRepository.findAll();
    }

    public void deletarMessage(Long id) {
        messageRepository.deleteById(id);
    }

}
