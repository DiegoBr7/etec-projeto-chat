package br.com.spring.chat.dto;

import br.com.spring.chat.model.Message;
import java.time.Instant;

public record MessageDTO(
        Long id,
        String content,
        String status,
        UserDTO sender,
        UserDTO receiver,
        Instant createdAt
) {
    public static MessageDTO fromEntity(Message m) {
        return new MessageDTO(
                m.getId(),
                m.getContent(),
                m.getStatus().name(),
                new UserDTO(m.getSender().getId(), m.getSender().getEmail(), m.getSender().getNome()),
                new UserDTO(m.getReceiver().getId(), m.getReceiver().getEmail(), m.getReceiver().getNome()),
                m.getCreatedAt()
        );
    }
}
