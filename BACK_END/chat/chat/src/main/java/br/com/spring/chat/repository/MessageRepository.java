package br.com.spring.chat.repository;

import br.com.spring.chat.model.Message;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface MessageRepository extends JpaRepository<Message , Long> {

    @Query("""
        SELECT m FROM Message m 
        WHERE 
            (m.sender.id = :user1 AND m.receiver.id = :user2)
         OR (m.sender.id = :user2 AND m.receiver.id = :user1)
        ORDER BY m.createdAt ASC
    """)
    List<Message> findChatBetween(@Param("user1") Long user1, @Param("user2") Long user2);

}
