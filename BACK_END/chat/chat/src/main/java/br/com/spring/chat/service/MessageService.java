package br.com.spring.chat.service;

import br.com.spring.chat.model.Message;
import br.com.spring.chat.model.User;
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

    /**
     * 🔹 Salva uma nova mensagem garantindo que remetente e destinatário existam.
     */
    public Message salvarMessage(Message message) {
        User sender = userRepository.findById(message.getSender().getId())
                .orElseThrow(() -> new IllegalArgumentException(
                        "Remetente não encontrado: " + message.getSender().getId()));

        User receiver = userRepository.findById(message.getReceiver().getId())
                .orElseThrow(() -> new IllegalArgumentException(
                        "Destinatário não encontrado: " + message.getReceiver().getId()));

        message.setSender(sender);
        message.setReceiver(receiver);
        return messageRepository.save(message);
    }

    /**
     * 🔹 Retorna todas as mensagens do banco (somente para debug ou administração).
     */
    public List<Message> listarMessages() {
        return messageRepository.findAll();
    }

    /**
     * 🔹 Retorna apenas as mensagens trocadas entre dois usuários específicos.
     */
    public List<Message> buscarChatEntre(Long user1, Long user2) {
        return messageRepository.findChatBetween(user1, user2);
    }

    /**
     * 🔹 Deleta uma mensagem pelo ID.
     */
    public void deletarMessage(Long id) {
        if (!messageRepository.existsById(id)) {
            throw new IllegalArgumentException("Mensagem não encontrada para id: " + id);
        }
        messageRepository.deleteById(id);
    }
}
